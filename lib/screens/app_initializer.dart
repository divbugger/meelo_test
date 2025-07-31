// lib/screens/app_initializer.dart - Simple app initialization without splash animation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_tabs_screen.dart';
import '../services/auth_service.dart';
import '../services/user_preferences_service.dart';
import '../services/deep_link_service.dart';
import 'auth/login_screen.dart';
import 'auth/onboarding_screen.dart';
import 'auth/email_verification_screen.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    // Initialize services
    final authService = Provider.of<AuthService>(context, listen: false);
    final preferencesService = Provider.of<UserPreferencesService>(context, listen: false);
    final deepLinkService = DeepLinkService();
    
    await authService.initialize();
    await preferencesService.initialize();
    
    // Initialize deep link service
    deepLinkService.initialize(context);

    // Brief delay to ensure services are fully initialized
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (mounted) {
      Widget nextScreen;
      
      if (authService.isAuthenticated) {
        // User is logged in
        await preferencesService.updateLastLogin();
        
        if (!authService.isEmailVerified) {
          // Email not verified, show verification screen
          nextScreen = EmailVerificationScreen(
            email: authService.currentUser?.email ?? '',
          );
        } else if (authService.isProfileComplete) {
          // Email verified and profile complete, go to main app
          nextScreen = const MainTabsScreen();
        } else {
          // Email verified but profile incomplete, go to onboarding
          nextScreen = const OnboardingScreen();
        }
      } else {
        // User is not authenticated, show login screen
        nextScreen = const LoginScreen();
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xFF483FA9),
            ),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}