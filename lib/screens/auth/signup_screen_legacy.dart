// Legacy signup screen - kept for reference
// New flow uses EmailRegistrationScreen -> PasswordSetupScreen

import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
//import '../../services/language_service.dart';
//import '../main_tabs_screen.dart';
import 'email_registration_screen.dart';

class SignupScreenLegacy extends StatefulWidget {
  final UserMode userMode;

  const SignupScreenLegacy({Key? key, required this.userMode}) : super(key: key);

  @override
  State<SignupScreenLegacy> createState() => _SignupScreenLegacyState();
}

class _SignupScreenLegacyState extends State<SignupScreenLegacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Registrierung',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 64,
              color: Color(0xFF483FA9),
            ),
            const SizedBox(height: 24),
            const Text(
              'Neue Registrierung',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Manrope',
                color: Color(0xFF483FA9),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Wir haben den Registrierungsprozess verbessert. Sie werden nun zur neuen Anmeldung weitergeleitet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Manrope',
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EmailRegistrationScreen(userMode: widget.userMode),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF483FA9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Zur neuen Registrierung',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Manrope',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}