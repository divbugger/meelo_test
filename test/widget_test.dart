// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meelo/main.dart';
import 'package:meelo/services/language_service.dart';
import 'package:meelo/services/auth_service.dart';
import 'package:meelo/services/user_preferences_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await dotenv.load(fileName: "dotenv.env");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? 'YOUR_SUPABASE_URL',
      anonKey: dotenv.env['SUPABASE_KEY'] ?? 'YOUR_SUPABASE_API_KEY',
    );
  });

  testWidgets('App initialization and main screen smoke test', (WidgetTester tester) async {
    final languageService = LanguageService();
    final authService = AuthService();
    final preferencesService = UserPreferencesService();
    // Optionally: await languageService.initialize();

    await tester.pumpWidget(MyApp(
      languageService: languageService,
      authService: authService,
      preferencesService: preferencesService,
    ));

    // Verify that the loading spinner is shown during initialization.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for navigation to complete (simulate app initialization delay and navigation).
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify that the main event screen is shown (app bar title: 'Add Rituals').
    expect(find.text('Add Rituals'), findsOneWidget);
  });
}