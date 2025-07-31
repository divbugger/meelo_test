import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/language_service.dart';
import '../../l10n/app_localizations.dart';
import '../main_tabs_screen.dart';

class PasswordSetupScreen extends StatefulWidget {
  final UserMode userMode;
  final String email;
  final bool stayLoggedIn;
  final String selectedLanguage;

  const PasswordSetupScreen({
    super.key,
    required this.userMode,
    required this.email,
    required this.stayLoggedIn,
    required this.selectedLanguage,
    });

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  DateTime? _selectedBirthDate;
  String _selectedGender = 'prefer_not_to_say';
  String _selectedLanguage = 'en';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _genders = [
    'male',
    'female',
    'non_binary',
    'prefer_not_to_say',
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF483FA9),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte wählen Sie Ihr Geburtsdatum')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final response = await authService.signUp(
        email: widget.email,
        password: _passwordController.text,
        // name: _nameController.text.trim(),
        // birthDate: _selectedBirthDate!,
        // gender: _selectedGender,
        // language: _selectedLanguage,
        // userMode: widget.userMode,  
      );

      if (response.user != null) {
        final languageService = Provider.of<LanguageService>(context, listen: false);
        await languageService.setLanguage(_selectedLanguage);

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainTabsScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.registrationFailed}: ${e.toString()}')),
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

  String _getGenderDisplayName(String gender) {
    switch (gender) {
      case 'male':
        return AppLocalizations.of(context)!.male;
      case 'female':
        return AppLocalizations.of(context)!.female;
      case 'non_binary':
        return AppLocalizations.of(context)!.nonBinary;
      case 'prefer_not_to_say':
        return AppLocalizations.of(context)!.preferNotToSay;
      default:
        return gender;
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF483FA9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                    widthFactor: 1.0, // 100% for step 2 of 2
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        AppLocalizations.of(context)!.createPassword,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height < 600 ? 24 : 32,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Manrope',
                          color: const Color(0xFF040506),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 20 : 32),

                      // User mode indicator
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF483FA9).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF483FA9).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              widget.userMode == UserMode.personWithDementia 
                                  ? Icons.person 
                                  : Icons.favorite,
                              color: const Color(0xFF483FA9),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${AppLocalizations.of(context)!.registrationAs} ${widget.userMode == UserMode.personWithDementia ? AppLocalizations.of(context)!.personWithDementia : AppLocalizations.of(context)!.caregiver}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF483FA9),
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 16 : 24),

                      // Name field
                      TextFormField(
                        controller: _nameController,
                        onTapOutside: (event) {
                          // Dismiss keyboard when tapping outside
                          FocusScope.of(context).unfocus();
                        },
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          color: Color(0xFF040506),
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.fullName,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF483FA9)),
                          ),
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF483FA9)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.enterFullName;
                          }
                          if (value.trim().length < 2) {
                            return AppLocalizations.of(context)!.nameMinLength;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 16 : 20),

                      // Birth date field
                      InkWell(
                        onTap: _selectBirthDate,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE6EEFE)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, color: Color(0xFF483FA9)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedBirthDate != null
                                      ? '${_selectedBirthDate!.day}.${_selectedBirthDate!.month}.${_selectedBirthDate!.year}'
                                      : AppLocalizations.of(context)!.selectBirthDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Manrope',
                                    color: _selectedBirthDate != null 
                                        ? const Color(0xFF040506)
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 16 : 20),

                      // Gender dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          color: Color(0xFF040506),
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.gender,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF483FA9)),
                          ),
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF483FA9)),
                        ),
                        items: _genders.map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(_getGenderDisplayName(gender)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedGender = value;
                            });
                          }
                        },
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 16 : 20),

                      // Language dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedLanguage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          color: Color(0xFF040506),
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.languagePreference,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF483FA9)),
                          ),
                          prefixIcon: const Icon(Icons.language_outlined, color: Color(0xFF483FA9)),
                        ),
                        items: [
                          DropdownMenuItem(value: 'en', child: Text(AppLocalizations.of(context)!.english)),
                          DropdownMenuItem(value: 'de', child: Text(AppLocalizations.of(context)!.german)),
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

                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 16 : 20),

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onTapOutside: (event) {
                          // Dismiss keyboard when tapping outside
                          FocusScope.of(context).unfocus();
                        },
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          color: Color(0xFF040506),
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.password,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF483FA9)),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF483FA9)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: const Color(0xFF483FA9),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.enterPassword;
                          }
                          if (value.length < 6) {
                            return AppLocalizations.of(context)!.passwordMinLength;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 16 : 20),

                      // Confirm password field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        onTapOutside: (event) {
                          // Dismiss keyboard when tapping outside
                          FocusScope.of(context).unfocus();
                        },
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Manrope',
                          color: Color(0xFF040506),
                        ),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.confirmPassword,
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Manrope',
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE6EEFE)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF483FA9)),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF483FA9)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                              color: const Color(0xFF483FA9),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.confirmYourPassword;
                          }
                          if (value != _passwordController.text) {
                            return AppLocalizations.of(context)!.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height < 600 ? 24 : 40),

                      // Create account button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF483FA9),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFD4D2D1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.createAccount,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 40),
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
}