import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserPreferencesService extends ChangeNotifier {
  static const String _userProfileKey = 'user_profile';
  static const String _appSettingsKey = 'app_settings';
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _lastLoginKey = 'last_login';

  Map<String, dynamic>? _userProfile;
  Map<String, dynamic> _appSettings = {};
  bool _onboardingCompleted = false;
  DateTime? _lastLogin;

  Map<String, dynamic>? get userProfile => _userProfile;
  Map<String, dynamic> get appSettings => _appSettings;
  bool get onboardingCompleted => _onboardingCompleted;
  DateTime? get lastLogin => _lastLogin;

  Future<void> initialize() async {
    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load user profile
      final profileJson = prefs.getString(_userProfileKey);
      if (profileJson != null) {
        _userProfile = json.decode(profileJson);
      }

      // Load app settings
      final settingsJson = prefs.getString(_appSettingsKey);
      if (settingsJson != null) {
        _appSettings = json.decode(settingsJson);
      } else {
        _appSettings = _getDefaultSettings();
      }

      // Load onboarding status
      _onboardingCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;

      // Load last login
      final lastLoginString = prefs.getString(_lastLoginKey);
      if (lastLoginString != null) {
        _lastLogin = DateTime.parse(lastLoginString);
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user preferences: $e');
      }
    }
  }

  Map<String, dynamic> _getDefaultSettings() {
    return {
      'notifications_enabled': true,
      'sound_enabled': true,
      'theme': 'light',
      'font_size': 'medium',
      'language': 'en',
      'accessibility_features': {
        'high_contrast': false,
        'large_text': false,
        'voice_guidance': false,
      },
      'privacy': {
        'data_sharing_enabled': false,
        'analytics_enabled': true,
      },
    };
  }

  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userProfileKey, json.encode(profile));
      _userProfile = profile;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user profile: $e');
      }
      throw Exception('Failed to save user profile');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    if (_userProfile == null) {
      await saveUserProfile(updates);
      return;
    }

    final updatedProfile = Map<String, dynamic>.from(_userProfile!);
    updatedProfile.addAll(updates);
    await saveUserProfile(updatedProfile);
  }

  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_appSettingsKey, json.encode(settings));
      _appSettings = settings;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving app settings: $e');
      }
      throw Exception('Failed to save app settings');
    }
  }

  Future<void> updateAppSetting(String key, dynamic value) async {
    final updatedSettings = Map<String, dynamic>.from(_appSettings);
    updatedSettings[key] = value;
    await saveAppSettings(updatedSettings);
  }

  Future<void> updateNestedAppSetting(String parentKey, String childKey, dynamic value) async {
    final updatedSettings = Map<String, dynamic>.from(_appSettings);
    if (updatedSettings[parentKey] is Map) {
      final nestedMap = Map<String, dynamic>.from(updatedSettings[parentKey]);
      nestedMap[childKey] = value;
      updatedSettings[parentKey] = nestedMap;
    } else {
      updatedSettings[parentKey] = {childKey: value};
    }
    await saveAppSettings(updatedSettings);
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, completed);
      _onboardingCompleted = completed;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving onboarding status: $e');
      }
    }
  }

  Future<void> updateLastLogin() async {
    try {
      final now = DateTime.now();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastLoginKey, now.toIso8601String());
      _lastLogin = now;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating last login: $e');
      }
    }
  }

  Future<void> clearAllPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _userProfile = null;
      _appSettings = _getDefaultSettings();
      _onboardingCompleted = false;
      _lastLogin = null;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing preferences: $e');
      }
      throw Exception('Failed to clear preferences');
    }
  }

  // Convenience getters for common settings
  bool get notificationsEnabled => _appSettings['notifications_enabled'] ?? true;
  bool get soundEnabled => _appSettings['sound_enabled'] ?? true;
  String get theme => _appSettings['theme'] ?? 'light';
  String get fontSize => _appSettings['font_size'] ?? 'medium';
  String get language => _appSettings['language'] ?? 'en';
  
  // Accessibility settings
  bool get highContrastEnabled => 
      (_appSettings['accessibility_features'] as Map?)?['high_contrast'] ?? false;
  bool get largeTextEnabled => 
      (_appSettings['accessibility_features'] as Map?)?['large_text'] ?? false;
  bool get voiceGuidanceEnabled => 
      (_appSettings['accessibility_features'] as Map?)?['voice_guidance'] ?? false;

  // Privacy settings
  bool get dataSharingEnabled => 
      (_appSettings['privacy'] as Map?)?['data_sharing_enabled'] ?? false;
  bool get analyticsEnabled => 
      (_appSettings['privacy'] as Map?)?['analytics_enabled'] ?? true;

  // User profile convenience getters
  String? get userName => _userProfile?['name'];
  String? get userEmail => _userProfile?['email'];
  String? get userGender => _userProfile?['gender'];
  DateTime? get userBirthDate {
    final birthDateString = _userProfile?['birth_date'];
    if (birthDateString != null) {
      try {
        return DateTime.parse(birthDateString);
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing birth date: $e');
        }
      }
    }
    return null;
  }
  String? get userMode => _userProfile?['user_mode'];

  // Helper methods
  int? calculateAge() {
    final birthDate = userBirthDate;
    if (birthDate != null) {
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month || 
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    }
    return null;
  }

  bool isFirstTimeUser() {
    return !_onboardingCompleted && _userProfile == null;
  }

  Duration? timeSinceLastLogin() {
    if (_lastLogin != null) {
      return DateTime.now().difference(_lastLogin!);
    }
    return null;
  }
}