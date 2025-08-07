import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../l10n/app_localizations.dart';
import '../main_tabs_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  
  // User data collected during onboarding
  UserMode? _selectedUserMode;
  String _name = '';
  DateTime? _birthDate;
  String _gender = ''; // This stores the database-compatible value
  String _displayGender = ''; // This stores the localized display text
  String _language = 'en'; // default to English
  
  bool _isLoading = false;

  // Map localized gender display text to database-compatible values
  String _getGenderDatabaseValue(String displayText, AppLocalizations localizations) {
    if (displayText == localizations.male || displayText == 'Male') {
      return 'Male';
    } else if (displayText == localizations.female || displayText == 'Female') {
      return 'Female';
    } else if (displayText == localizations.other || displayText == 'Other') {
      return 'Other';
    } else if (displayText == localizations.preferNotToSay || displayText == 'Prefer not to say') {
      return 'Prefer not to say';
    }
    return 'Male'; // fallback
  }

  // Get the current gender options for display
  List<String> _getGenderOptions(AppLocalizations localizations) {
    return [
      localizations.male,
      localizations.female,
      localizations.other,
      localizations.preferNotToSay,
    ];
  }
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Get current language from service
    final languageService = Provider.of<LanguageService>(context, listen: false);
    _language = languageService.currentLocale.languageCode;
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_selectedUserMode == null || _name.isEmpty || _birthDate == null || _displayGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.pleaseCompleteAllFields ?? 'Please complete all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.completeUserProfile(
        name: _name,
        birthDate: _birthDate!,
        gender: _gender,
        language: _language,
        userMode: _selectedUserMode!,
      );

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainTabsScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)?.failedToCompleteSetup ?? 'Failed to complete setup'}: ${e.toString()}'),
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
        body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress indicator
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      IconButton(
                        onPressed: _previousStep,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.setupYourProfile ?? 'Setup your profile',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Manrope',
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Progress bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _currentStep / 3, // 0/3, 1/3, 2/3, 3/3 (complete)
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildUserModeSelection(),
                  _buildNameInput(),
                  _buildBirthDateInput(),
                  _buildGenderSelection(),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildUserModeSelection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        // Main Content Card - Expanded to fill available space
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Step counter - moved to top-left
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)?.stepOf.replaceAll('{current}', '1').replaceAll('{total}', '4') ?? 'Step 1 of 4',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF483FA9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF483FA9),
                    size: 30,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Title
                Text(
                  AppLocalizations.of(context)?.howWillYouUse ?? 'How will you be using the app?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2d3748),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Subtitle
                Text(
                  AppLocalizations.of(context)?.selectRoleToPersonalize ?? 'Please select your role to personalize your experience',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
          
                // User mode cards side by side
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildModeCard(
                          mode: UserMode.personWithDementia,
                          title: AppLocalizations.of(context)?.personWithDementia ?? 'Person with Dementia',
                          icon: Icons.person,
                          isSelected: _selectedUserMode == UserMode.personWithDementia,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildModeCard(
                          mode: UserMode.caregiver,
                          title: AppLocalizations.of(context)?.caregiver ?? 'Caregiver',
                          icon: Icons.favorite,
                          isSelected: _selectedUserMode == UserMode.caregiver,
                        ),
                      ),
                    ],
                  ),
                ),
          
                
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Continue button outside the card - Dynamic styling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: _selectedUserMode != null 
                  ? const Color(0xFF3A2F7A)  // Dark purple when valid
                  : const Color(0xFFE8E8E8), // Light grey when invalid
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedUserMode != null 
                    ? const Color(0xFF2D2360)  // Darker purple border when valid
                    : const Color(0xFF9E9E9E), // Grey border when invalid
                width: 1.5,
              ),
              boxShadow: [
                // Black shadow for all button states
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _selectedUserMode != null ? _nextStep : null,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.continueText ?? 'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _selectedUserMode != null 
                          ? Colors.white           // White text when valid
                          : const Color(0xFF9E9E9E), // Grey text when invalid
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
      ],
    );
  }

  Widget _buildModeCard({
    required UserMode mode,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUserMode = mode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF483FA9) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF483FA9) 
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? const Color(0xFF483FA9) 
                    : const Color(0xFF2d3748),
              ),
              maxLines: 2,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF483FA9),
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        // Main Content Card - Expanded to fill available space
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Step counter - moved to top-left
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)?.stepOf.replaceAll('{current}', '2').replaceAll('{total}', '4') ?? 'Step 2 of 4',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF483FA9).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.badge_outlined,
                      color: Color(0xFF483FA9),
                      size: 30,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    AppLocalizations.of(context)?.whatsYourName ?? 'What\'s your name?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2d3748),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Subtitle
                  Text(
                    AppLocalizations.of(context)?.personalizeExperience ?? 'This will help us personalize your experience',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  TextFormField(
                    initialValue: _name,
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                    onTapOutside: (event) {
                      // Dismiss keyboard when tapping outside
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.fullName ?? 'Full Name',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Continue button outside the card - Dynamic styling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: _name.trim().isNotEmpty 
                  ? const Color(0xFF3A2F7A)  // Dark purple when valid
                  : const Color(0xFFE8E8E8), // Light grey when invalid
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _name.trim().isNotEmpty 
                    ? const Color(0xFF2D2360)  // Darker purple border when valid
                    : const Color(0xFF9E9E9E), // Grey border when invalid
                width: 1.5,
              ),
              boxShadow: [
                // Black shadow for all button states
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _name.trim().isNotEmpty ? _nextStep : null,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.continueText ?? 'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _name.trim().isNotEmpty 
                          ? Colors.white           // White text when valid
                          : const Color(0xFF9E9E9E), // Grey text when invalid
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
      ],
    );
  }

  Widget _buildBirthDateInput() {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        // Main Content Card - Expanded to fill available space
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Step counter - moved to top-left
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)?.stepOf.replaceAll('{current}', '3').replaceAll('{total}', '4') ?? 'Step 3 of 4',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF483FA9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.cake_outlined,
                    color: Color(0xFF483FA9),
                    size: 30,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Title
                Text(
                  AppLocalizations.of(context)?.whenWereYouBorn ?? 'When were you born?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2d3748),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Subtitle
                Text(
                  AppLocalizations.of(context)?.ageAppropriateContent ?? 'This helps us provide age-appropriate content',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _birthDate ?? DateTime(1960),
                      firstDate: DateTime(1920),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        _birthDate = date;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _birthDate != null
                                ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                                : AppLocalizations.of(context)?.selectBirthDate ?? 'Select your birth date',
                            style: TextStyle(
                              fontSize: 16,
                              color: _birthDate != null ? Colors.black : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Continue button outside the card - Dynamic styling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: _birthDate != null 
                  ? const Color(0xFF3A2F7A)  // Dark purple when valid
                  : const Color(0xFFE8E8E8), // Light grey when invalid
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _birthDate != null 
                    ? const Color(0xFF2D2360)  // Darker purple border when valid
                    : const Color(0xFF9E9E9E), // Grey border when invalid
                width: 1.5,
              ),
              boxShadow: [
                // Black shadow for all button states
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _birthDate != null ? _nextStep : null,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.continueText ?? 'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _birthDate != null 
                          ? Colors.white           // White text when valid
                          : const Color(0xFF9E9E9E), // Grey text when invalid
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
      ],
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        // Main Content Card - Expanded to fill available space
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Step counter - moved to top-left
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)?.stepOf.replaceAll('{current}', '4').replaceAll('{total}', '4') ?? 'Step 4 of 4',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF483FA9).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.wc_outlined,
                      color: Color(0xFF483FA9),
                      size: 30,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    AppLocalizations.of(context)?.howDoYouIdentify ?? 'How do you identify?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2d3748),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Subtitle
                  Text(
                    AppLocalizations.of(context)?.personalizeExperience ?? 'This helps us personalize your experience',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Column(
                    children: _getGenderOptions(AppLocalizations.of(context)!)
                        .map((genderOption) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _buildGenderOption(genderOption),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Continue button outside the card - Dynamic styling
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: (_displayGender.isNotEmpty && !_isLoading) 
                  ? const Color(0xFF3A2F7A)  // Dark purple when valid
                  : const Color(0xFFE8E8E8), // Light grey when invalid
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (_displayGender.isNotEmpty && !_isLoading) 
                    ? const Color(0xFF2D2360)  // Darker purple border when valid
                    : const Color(0xFF9E9E9E), // Grey border when invalid
                width: 1.5,
              ),
              boxShadow: [
                // Black shadow for all button states
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (_gender.isNotEmpty && !_isLoading) 
                    ? _completeOnboarding 
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)?.completeSetup ?? 'Complete Setup',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: (_gender.isNotEmpty && !_isLoading) 
                                ? Colors.white           // White text when valid
                                : const Color(0xFF9E9E9E), // Grey text when invalid
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 20),
        
      ],
    );
  }

  Widget _buildGenderOption(String displayGender) {
    final isSelected = _displayGender == displayGender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _displayGender = displayGender;
          _gender = _getGenderDatabaseValue(displayGender, AppLocalizations.of(context)!);
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF483FA9).withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF483FA9) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF483FA9) : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF483FA9) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              displayGender,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF483FA9) : const Color(0xFF2d3748),
              ),
            ),
          ],
        ),
      ),
    );
  }
}