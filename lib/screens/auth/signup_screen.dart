import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'email_registration_screen.dart';

class SignupScreen extends StatelessWidget {
  final UserMode userMode;

  const SignupScreen({Key? key, required this.userMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirect to new registration flow immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => EmailRegistrationScreen(userMode: userMode),
        ),
      );
    });
    
    // Show loading screen while redirecting
    return Scaffold(
      backgroundColor: const Color(0xFF483FA9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,
              ),
              child: const Center(
                child: Text(
                  'idem',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF483FA9),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Weiterleitung zur Registrierung...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}