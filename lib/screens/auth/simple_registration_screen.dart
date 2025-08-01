import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../l10n/app_localizations.dart';
import 'login_screen.dart';
import 'email_verification_screen.dart';

class SimpleRegistrationScreen extends StatefulWidget {
  const SimpleRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<SimpleRegistrationScreen> createState() => _SimpleRegistrationScreenState();
}

class _SimpleRegistrationScreenState extends State<SimpleRegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  String _selectedLanguage = 'en';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Get current language from service
    final languageService = Provider.of<LanguageService>(context, listen: false);
    _selectedLanguage = languageService.currentLocale.languageCode;

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.pleaseAcceptTerms ?? 'Please accept the terms and conditions'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Set the selected language before sign up
      final languageService = Provider.of<LanguageService>(context, listen: false);
      await languageService.changeLanguage(_selectedLanguage);

      final authService = Provider.of<AuthService>(context, listen: false);
      final response = await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null && mounted) {
        // Navigate to email verification screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EmailVerificationScreen(
              email: _emailController.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)?.registrationFailed ?? 'Registration failed'}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),

                      // Title
                      Text(
                        AppLocalizations.of(context)?.createAccount ?? 'Create Account',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2d3748),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        AppLocalizations.of(context)?.createAccountSubtitle ?? 'Create your account to get started',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Registration form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)?.email ?? 'Email Address',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(context)?.pleaseEnterEmail ?? 'Please enter your email address';
                                }
                                if (!value.contains('@') || !value.contains('.')) {
                                  return AppLocalizations.of(context)?.pleaseEnterValidEmail ?? 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)?.password ?? 'Password',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)?.pleaseEnterPassword ?? 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return AppLocalizations.of(context)?.passwordMinLengthMessage ?? 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Confirm Password field
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)?.confirmPassword ?? 'Confirm Password',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)?.pleaseConfirmPassword ?? 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return AppLocalizations.of(context)?.passwordsDontMatch ?? 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Language selection dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedLanguage,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Manrope',
                                color: Color(0xFF040506),
                              ),
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)?.languagePreference ?? 'Language Preference',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.language_outlined, color: Color(0xFF483FA9)),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'en',
                                  child: Text(AppLocalizations.of(context)?.english ?? 'English'),
                                ),
                                DropdownMenuItem(
                                  value: 'de',
                                  child: Text(AppLocalizations.of(context)?.german ?? 'Deutsch'),
                                ),
                              ],
                              onChanged: (value) async {
                                if (value != null && value != _selectedLanguage) {
                                  setState(() {
                                    _selectedLanguage = value;
                                  });
                                  // Change language immediately
                                  final languageService = Provider.of<LanguageService>(context, listen: false);
                                  await languageService.changeLanguage(value);
                                }
                              },
                            ),

                            const SizedBox(height: 20),

                            // Terms and conditions checkbox
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value ?? false;
                                    });
                                  },
                                  activeColor: const Color(0xFF483FA9),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      AppLocalizations.of(context)?.acceptTerms ?? 'I accept the Terms and Conditions and Privacy Policy',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // Create Account button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF483FA9),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                        AppLocalizations.of(context)?.createAccount ?? 'Create Account',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Back to login
                            Center(
                              child: TextButton(
                                onPressed: _navigateToLogin,
                                child: RichText(
                                  text: TextSpan(
                                    text: AppLocalizations.of(context)?.alreadyHaveAccount ?? 'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: AppLocalizations.of(context)?.signIn ?? 'Sign In',
                                        style: const TextStyle(
                                          color: Color(0xFF483FA9),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}