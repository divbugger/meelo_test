// lib/services/language_service.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  /// Initialize language service and load saved language preference
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  /// Change the app language
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode);

      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);

      notifyListeners();
    }
  }

  /// For compatibility: setLanguage is an alias for changeLanguage
  Future<void> setLanguage(String languageCode) async {
    await changeLanguage(languageCode);
  }

  /// Get language name for display
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      default:
        return 'English';
    }
  }

  /// Get supported languages
  List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch'},
    ];
  }

  /// Check if language is RTL (not needed for English/German but good for future)
  bool isRTL(String languageCode) {
    return false; // Neither English nor German are RTL
  }
}