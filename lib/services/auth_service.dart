import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';

enum UserMode { personWithDementia, caregiver }

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _currentUser;
  UserMode? _userMode;
  Map<String, dynamic>? _userProfile;

  User? get currentUser => _currentUser;
  UserMode? get userMode => _userMode;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isAuthenticated => _currentUser != null;
  bool get isEmailVerified => _currentUser?.emailConfirmedAt != null;
  bool get isProfileComplete => _userProfile != null && 
      _userProfile!['name'] != null && 
      _userProfile!['birth_date'] != null && 
      _userProfile!['gender'] != null && 
      _userProfile!['language'] != null && 
      _userProfile!['user_mode'] != null;

  AuthService() {
    _supabase.auth.onAuthStateChange.listen((data) {
      _currentUser = data.session?.user;
      if (_currentUser != null) {
        _loadUserProfile();
      } else {
        _userProfile = null;
        _userMode = null;
      }
      notifyListeners();
    });
  }

  Future<void> initialize() async {
    _currentUser = _supabase.auth.currentUser;
    if (_currentUser != null) {
      await _loadUserProfile();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Simplified signUp - only email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = response.user;
        // Profile will be completed during onboarding
        _userProfile = null;
        _userMode = null;
        notifyListeners();
      }

      return response;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _currentUser = response.user;
        await _loadUserProfile();
        notifyListeners();
      }

      return response;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _currentUser = null;
      _userProfile = null;
      _userMode = null;
      await _clearUserModeLocally();
      notifyListeners();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser == null) return;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', _currentUser!.id)
          .single();

      _userProfile = response;
      
      if (response['user_mode'] != null) {
        _userMode = UserMode.values.firstWhere(
          (mode) => mode.name == response['user_mode'],
          orElse: () => UserMode.personWithDementia,
        );
        await _saveUserModeLocally(_userMode!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user profile: $e');
      }
    }
  }

  Future<void> _saveUserModeLocally(UserMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_mode', mode.name);
  }

  Future<void> _clearUserModeLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_mode');
  }

  Future<UserMode?> getSavedUserMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('user_mode');
    if (savedMode != null) {
      return UserMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => UserMode.personWithDementia,
      );
    }
    return null;
  }

  // Complete user profile during onboarding
  Future<void> completeUserProfile({
    required String name,
    required DateTime birthDate,
    required String gender,
    required String language,
    required UserMode userMode,
  }) async {
    if (_currentUser == null) return;

    try {
      final profileData = {
        'id': _currentUser!.id,
        'name': name,
        'birth_date': birthDate.toIso8601String(),
        'gender': gender,
        'language': language,
        'user_mode': userMode.name,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Use upsert to handle both insert and update cases
      await _supabase
          .from('profiles')
          .upsert(profileData);

      _userMode = userMode;
      _userProfile = profileData;
      await _saveUserModeLocally(userMode);
      notifyListeners();
    } catch (e) {
      throw Exception('Profile completion failed: $e');
    }
  }

  Future<void> updateUserProfile({
    String? name,
    DateTime? birthDate,
    String? gender,
    String? language,
  }) async {
    if (_currentUser == null) return;

    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (birthDate != null) updates['birth_date'] = birthDate.toIso8601String();
      if (gender != null) updates['gender'] = gender;
      if (language != null) updates['language'] = language;

      await _supabase
          .from('profiles')
          .update(updates)
          .eq('id', _currentUser!.id);

      await _loadUserProfile();
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  // Email verification methods
  Future<bool> checkEmailVerification() async {
    try {
      // Check if we have a current user first
      final user = _supabase.auth.currentUser;
      
      if (user != null) {
        // Only refresh session if we have an existing session
        if (_supabase.auth.currentSession != null) {
          await _supabase.auth.refreshSession();
        }
        
        _currentUser = _supabase.auth.currentUser;
        notifyListeners();
        return _currentUser?.emailConfirmedAt != null;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking email verification: $e');
      }
      return false;
    }
  }

  Future<void> resendVerificationEmail() async {
    if (_currentUser?.email == null) {
      throw Exception('No user email found');
    }

    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: _currentUser!.email!,
      );
    } catch (e) {
      throw Exception('Failed to resend verification email: $e');
    }
  }

  Future<void> handleEmailVerification(String accessToken, String refreshToken) async {
    try {
      // Set the session with the tokens from the email verification
      await _supabase.auth.setSession(accessToken);
      
      // Update current user
      _currentUser = _supabase.auth.currentUser;
      
      if (_currentUser != null) {
        await _loadUserProfile();
      }
      
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to handle email verification: $e');
    }
  }

  String getDisplayName() {
    if (_userProfile != null && _userProfile!['name'] != null) {
      return _userProfile!['name'];
    }
    return _currentUser?.email?.split('@').first ?? 'User';
  }
}