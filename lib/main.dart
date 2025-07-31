// lib/main.dart - Complete updated version with white background theme and Idem branding

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'screens/app_initializer.dart';
import 'services/language_service.dart';
import 'services/auth_service.dart';
import 'services/user_preferences_service.dart';
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

    // Start the app after successful initialization
    runApp(MyApp(
      languageService: languageService,
      authService: authService,
      preferencesService: preferencesService,
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

  const MyApp({
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
              fontFamily: 'Manrope', // Use Manrope as default font
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 72, 13, 174),
                brightness: Brightness.light, // Ensure light theme
              ),
              useMaterial3: true,

              // White background theme
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.white,
              canvasColor: Colors.white,

              // AppBar theme with white background
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 1,
                shadowColor: Colors.black12,
                titleTextStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              // Bottom navigation theme
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Color.fromARGB(255, 72, 13, 174),
                unselectedItemColor: Colors.grey,
                elevation: 8,
                type: BottomNavigationBarType.fixed,
              ),

              // FloatingActionButton theme
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Color.fromARGB(255, 72, 13, 174),
                foregroundColor: Colors.white,
              ),

              // ElevatedButton theme
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 72, 13, 174),
                  foregroundColor: Colors.white,
                ),
              ),

              // OutlinedButton theme
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 72, 13, 174),
                  side:
                      const BorderSide(color: Color.fromARGB(255, 72, 13, 174)),
                ),
              ),

              // Input decoration theme
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 72, 13, 174)),
                ),
                floatingLabelStyle: TextStyle(
                  color: Color.fromARGB(255, 72, 13, 174),
                ),
              ),
            ),
            home: const AppInitializer(), // Start with app initializer (no splash animation)
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
                            color: Colors.white.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
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
                                    color: Colors.white.withOpacity(0.9),
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