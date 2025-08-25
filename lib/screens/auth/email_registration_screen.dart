import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
//import '../../services/language_service.dart';
import '../../l10n/app_localizations.dart';
import 'password_setup_screen.dart';

class EmailRegistrationScreen extends StatefulWidget {
  final UserMode userMode;
  
  const EmailRegistrationScreen({Key? key, required this.userMode}) : super(key: key);

  @override
  State<EmailRegistrationScreen> createState() => _EmailRegistrationScreenState();
}

class _EmailRegistrationScreenState extends State<EmailRegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _termsAccepted = false;
  bool _stayLoggedIn = true;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _isEmailValid = email.isNotEmpty && email.contains('@') && email.contains('.');
    });
  }

  bool get _canContinue => _isEmailValid && _termsAccepted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside of text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF483FA9),
        resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF483FA9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.register,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Manrope',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Handle done action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.5, // 50% for step 1 of 2
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Text(
                        AppLocalizations.of(context)!.whatIsYourEmail,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height < 600 ? 24 : 32,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Manrope',
                          color: const Color(0xFF040506),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 20 : 32),
                  
                  // Email input field
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE6EEFE),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        color: Color(0xFF040506),
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.emailPlaceholder,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF483FA9),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height < 600 ? 20 : 32),
                  
                  // Terms & conditions checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (value) {
                          setState(() {
                            _termsAccepted = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF483FA9),
                        checkColor: Colors.white,
                        side: BorderSide(
                          color: _termsAccepted 
                              ? const Color(0xFF483FA9) 
                              : const Color(0xFFE6EEFE),
                          width: 2,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            AppLocalizations.of(context)!.acceptTerms,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Manrope',
                              color: Color(0xFF040506),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Stay logged in checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _stayLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            _stayLoggedIn = value ?? false;
                          });
                        },
                        activeColor: const Color(0xFF483FA9),
                        checkColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFF483FA9),
                          width: 2,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.stayLoggedIn,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Manrope',
                          color: Color(0xFF040506),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: MediaQuery.of(context).size.height < 600 ? 40 : 60),
                  
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _canContinue ? _handleContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canContinue 
                            ? const Color(0xFF483FA9) 
                            : const Color(0xFFD4D2D1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.continueButton,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                              color: _canContinue ? Colors.white : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: _canContinue ? Colors.white : Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _handleContinue() {
    if (_canContinue) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PasswordSetupScreen(
            userMode: widget.userMode,
            email: _emailController.text.trim(),
            stayLoggedIn: _stayLoggedIn,
            selectedLanguage: 'en', // Default language since selection is now in simple registration
          ),
        ),
      );
    }
  }
}