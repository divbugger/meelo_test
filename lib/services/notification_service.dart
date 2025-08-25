import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:meelo/models/user_preferences.dart';

class NotificationService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();
  
  UserPreferences? _userPreferences;
  bool _isLoading = false;

  UserPreferences? get userPreferences => _userPreferences;
  NotificationSettings? get notificationSettings => _userPreferences?.notifications;
  bool get isLoading => _isLoading;

  Future<void> loadUserPreferences() async {
    if (_supabase.auth.currentUser == null) return;

    _setLoading(true);
    try {
      final response = await _supabase
          .from('user_preferences')
          .select()
          .eq('user_id', _supabase.auth.currentUser!.id)
          .maybeSingle();

      if (response != null) {
        _userPreferences = UserPreferences.fromJson(response);
      } else {
        await _createDefaultPreferences();
      }
      
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading user preferences: $error');
      await _createDefaultPreferences();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _createDefaultPreferences() async {
    if (_supabase.auth.currentUser == null) return;

    try {
      final defaultPreferences = UserPreferences(
        id: _uuid.v4(),
        userId: _supabase.auth.currentUser!.id,
        notifications: const NotificationSettings(),
        updatedAt: DateTime.now(),
      );

      await _supabase
          .from('user_preferences')
          .insert(defaultPreferences.toJson());

      _userPreferences = defaultPreferences;
      notifyListeners();
    } catch (error) {
      debugPrint('Error creating default preferences: $error');
    }
  }

  Future<bool> updateNotificationSettings(NotificationSettings settings) async {
    if (_userPreferences == null) return false;

    try {
      final updatedPreferences = _userPreferences!.copyWith(
        notifications: settings,
        updatedAt: DateTime.now(),
      );

      await _supabase
          .from('user_preferences')
          .update(updatedPreferences.toJson())
          .eq('id', _userPreferences!.id);

      _userPreferences = updatedPreferences;
      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('Error updating notification settings: $error');
      return false;
    }
  }

  Future<bool> updateStoriesNotification(bool enabled) async {
    if (notificationSettings == null) return false;
    
    final updatedSettings = notificationSettings!.copyWith(storiesEnabled: enabled);
    return await updateNotificationSettings(updatedSettings);
  }

  Future<bool> updateFamilyUpdatesNotification(bool enabled) async {
    if (notificationSettings == null) return false;
    
    final updatedSettings = notificationSettings!.copyWith(familyUpdatesEnabled: enabled);
    return await updateNotificationSettings(updatedSettings);
  }

  Future<bool> updateRemindersNotification(bool enabled) async {
    if (notificationSettings == null) return false;
    
    final updatedSettings = notificationSettings!.copyWith(remindersEnabled: enabled);
    return await updateNotificationSettings(updatedSettings);
  }

  Future<bool> updateGeneralNotifications(bool enabled) async {
    if (notificationSettings == null) return false;
    
    final updatedSettings = notificationSettings!.copyWith(generalNotificationsEnabled: enabled);
    return await updateNotificationSettings(updatedSettings);
  }

  Future<bool> updateDataCollectionConsent(bool consent) async {
    if (_userPreferences == null) return false;

    try {
      final updatedPreferences = _userPreferences!.copyWith(
        dataCollectionConsent: consent,
        updatedAt: DateTime.now(),
      );

      await _supabase
          .from('user_preferences')
          .update(updatedPreferences.toJson())
          .eq('id', _userPreferences!.id);

      _userPreferences = updatedPreferences;
      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('Error updating data collection consent: $error');
      return false;
    }
  }

  Future<bool> updateMarketingEmailsEnabled(bool enabled) async {
    if (_userPreferences == null) return false;

    try {
      final updatedPreferences = _userPreferences!.copyWith(
        marketingEmailsEnabled: enabled,
        updatedAt: DateTime.now(),
      );

      await _supabase
          .from('user_preferences')
          .update(updatedPreferences.toJson())
          .eq('id', _userPreferences!.id);

      _userPreferences = updatedPreferences;
      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('Error updating marketing emails preference: $error');
      return false;
    }
  }

  Future<bool> updateCustomSetting(String key, dynamic value) async {
    if (_userPreferences == null) return false;

    try {
      final customSettings = Map<String, dynamic>.from(_userPreferences!.customSettings ?? {});
      customSettings[key] = value;

      final updatedPreferences = _userPreferences!.copyWith(
        customSettings: customSettings,
        updatedAt: DateTime.now(),
      );

      await _supabase
          .from('user_preferences')
          .update(updatedPreferences.toJson())
          .eq('id', _userPreferences!.id);

      _userPreferences = updatedPreferences;
      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('Error updating custom setting: $error');
      return false;
    }
  }

  dynamic getCustomSetting(String key, {dynamic defaultValue}) {
    return _userPreferences?.customSettings?[key] ?? defaultValue;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}