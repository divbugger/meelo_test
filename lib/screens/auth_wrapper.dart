// lib/screens/auth_wrapper.dart - Authentication state wrapper for automatic navigation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'main_tabs_screen.dart';
import 'auth/onboarding_screen.dart';
import 'auth/email_verification_screen.dart';
import 'auth/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize AuthService when wrapper is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAuthService();
    });
  }

  Future<void> _initializeAuthService() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while initializing
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF483FA9)),
          ),
        ),
      );
    }

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        print('AuthWrapper: isAuthenticated = ${authService.isAuthenticated}');
        print('AuthWrapper: currentUser = ${authService.currentUser?.email}');
        
        // User is not authenticated - show login screen directly
        if (!authService.isAuthenticated) {
          return const LoginScreen();
        }

        // User is authenticated - check profile completeness and email verification
        if (!authService.isEmailVerified) {
          // Email not verified, show verification screen
          return EmailVerificationScreen(
            email: authService.currentUser?.email ?? '',
          );
        } else if (!authService.isProfileComplete) {
          // Email verified but profile incomplete, go to onboarding
          return const OnboardingScreen();
        } else {
          // Everything is complete, show main app
          return const MainTabsScreen();
        }
      },
    );
  }
}