import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import '../screens/main_tabs_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  BuildContext? _context;
  bool _isInitialized = false;

  void initialize(BuildContext context) {
    _context = context;
    if (!_isInitialized) {
      _initDeepLinks();
      _isInitialized = true;
    }
  }

  void _initDeepLinks() {
    // Handle deep links when app is already running
    _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint('Deep link error: $err');
      },
    );

    // Handle deep link when app is launched from a deep link
    _handleInitialLink();
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (e) {
      debugPrint('Failed to get initial link: $e');
    }
  }

  void _handleDeepLink(Uri uri) {
    if (_context == null) return;

    debugPrint('Handling deep link: $uri');

    // Parse the deep link
    final scheme = uri.scheme;
    final host = uri.host;
    final path = uri.path;
    final queryParams = uri.queryParameters;

    // Handle email verification links
    if ((scheme == 'meelo' && host == 'auth') || 
        (scheme == 'https' && host == 'meelo.app' && path.startsWith('/auth'))) {
      _handleAuthCallback(queryParams);
    }
  }

  Future<void> _handleAuthCallback(Map<String, String> queryParams) async {
    if (_context == null) return;

    try {
      // Check for Supabase auth tokens in the URL
      final accessToken = queryParams['access_token'];
      final refreshToken = queryParams['refresh_token'];
      final type = queryParams['type'];
      final error = queryParams['error'];
      final errorDescription = queryParams['error_description'];

      // Handle authentication errors
      if (error != null) {
        _showErrorAndNavigateToLogin(errorDescription ?? error);
        return;
      }

      // Handle successful email verification
      if (type == 'signup' && accessToken != null && refreshToken != null) {
        await _handleEmailVerificationSuccess(accessToken, refreshToken);
      } else if (type == 'recovery' && accessToken != null && refreshToken != null) {
        await _handlePasswordResetSuccess(accessToken, refreshToken);
      } else {
        // Unknown auth callback, redirect to login
        _navigateToLogin();
      }
    } catch (e) {
      debugPrint('Error handling auth callback: $e');
      _showErrorAndNavigateToLogin('Verification failed. Please try again.');
    }
  }

  Future<void> _handleEmailVerificationSuccess(String accessToken, String refreshToken) async {
    if (_context == null) return;

    try {
      // Show loading indicator
      _showLoadingDialog();

      final authService = Provider.of<AuthService>(_context!, listen: false);
      
      // Handle the verification in AuthService
      await authService.handleEmailVerification(accessToken, refreshToken);
      
      // Hide loading dialog
      Navigator.of(_context!).pop();

      // Navigate based on profile completion status
      if (authService.isProfileComplete) {
        // Profile is complete, go to main app
        Navigator.of(_context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainTabsScreen()),
          (route) => false,
        );
      } else {
        // Profile is incomplete, go to onboarding
        Navigator.of(_context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false,
        );
      }

      // Show success message
      ScaffoldMessenger.of(_context!).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Hide loading dialog if still showing
      if (Navigator.of(_context!).canPop()) {
        Navigator.of(_context!).pop();
      }
      
      _showErrorAndNavigateToLogin('Email verification failed. Please try logging in again.');
    }
  }

  Future<void> _handlePasswordResetSuccess(String accessToken, String refreshToken) async {
    if (_context == null) return;

    try {
      final authService = Provider.of<AuthService>(_context!, listen: false);
      await authService.handleEmailVerification(accessToken, refreshToken);
      
      // Navigate to a password reset screen (implement if needed)
      // For now, navigate to main app or onboarding
      if (authService.isProfileComplete) {
        Navigator.of(_context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainTabsScreen()),
          (route) => false,
        );
      } else {
        Navigator.of(_context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (route) => false,
        );
      }

      ScaffoldMessenger.of(_context!).showSnackBar(
        const SnackBar(
          content: Text('Password reset successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorAndNavigateToLogin('Password reset failed. Please try again.');
    }
  }

  void _showLoadingDialog() {
    if (_context == null) return;

    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF483FA9),
            ),
            const SizedBox(height: 16),
            Text(
              'Verifying your email...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorAndNavigateToLogin(String message) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );

    _navigateToLogin();
  }

  void _navigateToLogin() {
    if (_context == null) return;

    Navigator.of(_context!).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void dispose() {
    _context = null;
    _isInitialized = false;
  }
}