class NotificationSettings {
  final bool storiesEnabled;
  final bool familyUpdatesEnabled;
  final bool remindersEnabled;
  final bool generalNotificationsEnabled;

  const NotificationSettings({
    this.storiesEnabled = true,
    this.familyUpdatesEnabled = true,
    this.remindersEnabled = true,
    this.generalNotificationsEnabled = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      storiesEnabled: json['stories_enabled'] as bool? ?? true,
      familyUpdatesEnabled: json['family_updates_enabled'] as bool? ?? true,
      remindersEnabled: json['reminders_enabled'] as bool? ?? true,
      generalNotificationsEnabled: json['general_notifications_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stories_enabled': storiesEnabled,
      'family_updates_enabled': familyUpdatesEnabled,
      'reminders_enabled': remindersEnabled,
      'general_notifications_enabled': generalNotificationsEnabled,
    };
  }

  NotificationSettings copyWith({
    bool? storiesEnabled,
    bool? familyUpdatesEnabled,
    bool? remindersEnabled,
    bool? generalNotificationsEnabled,
  }) {
    return NotificationSettings(
      storiesEnabled: storiesEnabled ?? this.storiesEnabled,
      familyUpdatesEnabled: familyUpdatesEnabled ?? this.familyUpdatesEnabled,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      generalNotificationsEnabled: generalNotificationsEnabled ?? this.generalNotificationsEnabled,
    );
  }
}

class UserPreferences {
  final String id;
  final String userId;
  final NotificationSettings notifications;
  final bool dataCollectionConsent;
  final bool marketingEmailsEnabled;
  final String? preferredLanguage;
  final Map<String, dynamic>? customSettings;
  final DateTime updatedAt;

  const UserPreferences({
    required this.id,
    required this.userId,
    required this.notifications,
    this.dataCollectionConsent = true,
    this.marketingEmailsEnabled = false,
    this.preferredLanguage,
    this.customSettings,
    required this.updatedAt,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      notifications: NotificationSettings.fromJson(json['notifications'] as Map<String, dynamic>? ?? {}),
      dataCollectionConsent: json['data_collection_consent'] as bool? ?? true,
      marketingEmailsEnabled: json['marketing_emails_enabled'] as bool? ?? false,
      preferredLanguage: json['preferred_language'] as String?,
      customSettings: json['custom_settings'] as Map<String, dynamic>?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'notifications': notifications.toJson(),
      'data_collection_consent': dataCollectionConsent,
      'marketing_emails_enabled': marketingEmailsEnabled,
      'preferred_language': preferredLanguage,
      'custom_settings': customSettings,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserPreferences copyWith({
    String? id,
    String? userId,
    NotificationSettings? notifications,
    bool? dataCollectionConsent,
    bool? marketingEmailsEnabled,
    String? preferredLanguage,
    Map<String, dynamic>? customSettings,
    DateTime? updatedAt,
  }) {
    return UserPreferences(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notifications: notifications ?? this.notifications,
      dataCollectionConsent: dataCollectionConsent ?? this.dataCollectionConsent,
      marketingEmailsEnabled: marketingEmailsEnabled ?? this.marketingEmailsEnabled,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      customSettings: customSettings ?? this.customSettings,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}