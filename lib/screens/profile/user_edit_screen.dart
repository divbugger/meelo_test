import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meelo/services/auth_service.dart';
import 'package:meelo/l10n/app_localizations.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({super.key});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userProfile = authService.userProfile;
    
    if (userProfile != null) {
      _nameController.text = userProfile['name'] ?? '';
      _nicknameController.text = userProfile['nickname'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF040506)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.editProfile,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF040506),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xFF483FA9),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              // TODO: Implement photo upload
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Photo upload coming soon'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Full Name Field
                Text(
                  localizations.fullName,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF040506),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: localizations.enterFullName,
                    hintStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF483FA9)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations.enterFullName;
                    }
                    if (value.length < 2) {
                      return localizations.nameMinLength;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Nickname Field
                Text(
                  localizations.nickname,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF040506),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nicknameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: localizations.enterNickname,
                    hintStyle: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF483FA9)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Email Field (Read-only)
                Text(
                  localizations.email,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF040506),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          authService.currentUser?.email ?? '',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF483FA9),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            localizations.save,
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;

    try {
      // Update profile in Supabase
      await authService.updateUserProfile(
        name: _nameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.profileUpdated),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.failedToUpdateProfile),
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
}