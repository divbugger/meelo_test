// lib/main.dart - Complete updated version with white background theme and Idem branding

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/auth_wrapper.dart';
import 'services/language_service.dart';
import 'services/auth_service.dart';
import 'services/user_preferences_service.dart';
import 'services/family_service.dart';
import 'services/figure_status_service.dart';
import 'services/notification_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services that do NOT use Supabase.instance
  final languageService = LanguageService();
  await languageService.initialize();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: "dotenv.env");
    print('Environment variables loaded successfully');
  } catch (e) {
    print(
      'Warning: .env file not found or could not be loaded. Using fallback credentials.',
    );
  }

  // Initialize Supabase with proper error handling
  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? 'YOUR_SUPABASE_URL',
      anonKey: dotenv.env['SUPABASE_KEY'] ?? 'YOUR_SUPABASE_API_KEY',
    );

    // Now it's safe to create services that use Supabase.instance
    final authService = AuthService();
    final preferencesService = UserPreferencesService();
    final familyService = FamilyService();
    final figureStatusService = FigureStatusService();
    final notificationService = NotificationService();

    // Start the app after successful initialization
    runApp(MyApp(
      languageService: languageService,
      authService: authService,
      preferencesService: preferencesService,
      familyService: familyService,
      figureStatusService: figureStatusService,
      notificationService: notificationService,
    ));
  } catch (e) {
    // Handle initialization errors gracefully
    print('Supabase initialization error: $e');

    // Still run the app, but it will show an error screen
    runApp(
      MyAppWithError(
        'Failed to connect to the database. Please check your internet connection.',
        languageService: languageService,
        authService: AuthService(), // fallback, but may still error
        preferencesService: UserPreferencesService(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final LanguageService languageService;
  final AuthService authService;
  final UserPreferencesService preferencesService;
  final FamilyService familyService;
  final FigureStatusService figureStatusService;
  final NotificationService notificationService;

  const MyApp({
    Key? key, 
    required this.languageService,
    required this.authService,
    required this.preferencesService,
    required this.familyService,
    required this.figureStatusService,
    required this.notificationService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageService),
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider.value(value: preferencesService),
        ChangeNotifierProvider.value(value: familyService),
        ChangeNotifierProvider.value(value: figureStatusService),
        ChangeNotifierProvider.value(value: notificationService),
      ],
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return MaterialApp(
            title: 'meelo',

            // Localization setup
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: languageService.currentLocale,

            theme: ThemeData(
              fontFamily: 'Manrope', // Use Manrope as default font
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF483FA9), // Primary purple from thematic.png
                brightness: Brightness.light,
                primary: const Color(0xFF483FA9),
                secondary: const Color(0xFFFF8C00), // Orange accent from thematic.png
                surface: Colors.white,
                background: const Color(0xFFF8F9FA), // Light background
              ),
              useMaterial3: true,

              // White background theme
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.white,
              canvasColor: Colors.white,

              // AppBar theme with white background
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF040506),
                elevation: 1,
                shadowColor: Colors.black12,
                titleTextStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF040506),
                ),
              ),

              // Bottom navigation theme matching thematic.png
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Color(0xFF483FA9),
                unselectedItemColor: Color(0xFF9CA3AF),
                elevation: 8,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),

              // FloatingActionButton theme with orange accent
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color(0xFFFF8C00), // Orange from thematic.png
                foregroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),

              // ElevatedButton theme
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF483FA9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),

              // OutlinedButton theme
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF483FA9),
                  side: const BorderSide(color: Color(0xFF483FA9), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Card theme
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 2,
                shadowColor: Colors.black.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // Input decoration theme
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF483FA9), width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                floatingLabelStyle: const TextStyle(
                  color: Color(0xFF483FA9),
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
                labelStyle: TextStyle(
                  fontFamily: 'Manrope',
                  color: Colors.grey.shade600,
                ),
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
              ),

              // Text theme
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF040506),
                ),
                displayMedium: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF040506),
                ),
                displaySmall: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF040506),
                ),
                headlineLarge: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF040506),
                ),
                headlineMedium: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF040506),
                ),
                headlineSmall: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF040506),
                ),
                titleLarge: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF040506),
                ),
                titleMedium: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF040506),
                ),
                titleSmall: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF040506),
                ),
                bodyLarge: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF040506),
                ),
                bodyMedium: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF040506),
                ),
                bodySmall: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7280),
                ),
                labelLarge: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF040506),
                ),
                labelMedium: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF040506),
                ),
                labelSmall: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            home: const AuthWrapper(), // Start with authentication wrapper for automatic navigation
            debugShowCheckedModeBanner:
                false, // Remove debug banner for cleaner look
          );
        },
      ),
    );
  }
}

// Error fallback app
class MyAppWithError extends StatelessWidget {
  final String errorMessage;
  final LanguageService languageService;
  final AuthService authService;
  final UserPreferencesService preferencesService;

  const MyAppWithError(
    this.errorMessage, {
    Key? key,
    required this.languageService,
    required this.authService,
    required this.preferencesService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageService),
        ChangeNotifierProvider.value(value: authService),
        ChangeNotifierProvider.value(value: preferencesService),
      ],
      child: Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return MaterialApp(
            title: 'meelo',

            // Localization setup
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: languageService.currentLocale,

            theme: ThemeData(
              fontFamily: 'Manrope',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 72, 13, 174),
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
            ),
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFf8f9fa),
                      Color(0xFFe9ecef),
                      Color(0xFFd1a3d9),
                      Color(0xFF9c6bb5),
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            color: Colors.white.withValues(alpha: 0.9),
                            boxShadow: [
                              BoxShadow(
                                                                 color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'meelo',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2d3748),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Application Error',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            // Simple restart attempt
                            main();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF9c6bb5),
                          ),
                          child: const Text('Retry Connection'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}