import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
//import '../../l10n/app_localizations.dart';
import 'email_registration_screen.dart';

class UserModeSelectionScreen extends StatefulWidget {
  const UserModeSelectionScreen({Key? key}) : super(key: key);

  @override
  State<UserModeSelectionScreen> createState() => _UserModeSelectionScreenState();
}

class _UserModeSelectionScreenState extends State<UserModeSelectionScreen>
    with TickerProviderStateMixin {
  UserMode? _selectedMode;
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onModeSelected(UserMode mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  void _onContinue() {
    if (_selectedMode != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EmailRegistrationScreen(userMode: _selectedMode!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: const Color(0xFF483FA9),
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
                      const SizedBox(height: 80),

                      // Title
                      Text(
                        'Welcome to meelo',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Please select how you will be using the app:',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // User mode selection cards - Horizontal layout
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildModeCard(
                                mode: UserMode.personWithDementia,
                                title: 'Person with Dementia',
                                subtitle: 'I am someone living with dementia and want to use this app to help with my daily activities and memories.',
                                icon: Icons.person,
                                isSelected: _selectedMode == UserMode.personWithDementia,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildModeCard(
                                mode: UserMode.caregiver,
                                title: 'Caregiver',
                                subtitle: 'I am a caregiver, family member, or friend helping someone with dementia.',
                                icon: Icons.favorite,
                                isSelected: _selectedMode == UserMode.caregiver,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _selectedMode != null ? _onContinue : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 72, 13, 174),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
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

  Widget _buildModeCard({
    required UserMode mode,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _onModeSelected(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF483FA9) : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon at the top
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF483FA9) 
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? const Color(0xFF483FA9) 
                    : const Color(0xFF2d3748),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Selection indicator at bottom
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF483FA9),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}