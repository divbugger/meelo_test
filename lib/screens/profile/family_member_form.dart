import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meelo/models/family_member.dart';
import 'package:meelo/services/family_service.dart';
import 'package:meelo/l10n/app_localizations.dart';

class FamilyMemberForm extends StatefulWidget {
  const FamilyMemberForm({super.key});

  @override
  State<FamilyMemberForm> createState() => _FamilyMemberFormState();
}

class _FamilyMemberFormState extends State<FamilyMemberForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  
  FamilyRelation? _selectedRelation;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final familyService = Provider.of<FamilyService>(context);

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
          localizations.inviteFamilyMember,
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
                // Name Field (Optional)
                Text(
                  localizations.familyMemberNameOptional,
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
                
                // Email Field
                Text(
                  localizations.familyMemberEmail,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF040506),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: localizations.emailPlaceholder,
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
                      return localizations.pleaseEnterEmail;
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return localizations.pleaseEnterValidEmail;
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Relation Dropdown
                Text(
                  localizations.relation,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF040506),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<FamilyRelation>(
                  value: _selectedRelation,
                  decoration: InputDecoration(
                    hintText: localizations.selectRelation,
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
                  items: FamilyRelation.values.map((relation) {
                    return DropdownMenuItem(
                      value: relation,
                      child: Text(
                        _getRelationLocalizedName(relation, localizations),
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRelation = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return localizations.selectRelation;
                    }
                    return null;
                  },
                ),
                
                const Spacer(),
                
                // Send Invitation Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendInvitation,
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
                            localizations.sendInvitation,
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

  String _getRelationLocalizedName(FamilyRelation relation, AppLocalizations localizations) {
    switch (relation) {
      case FamilyRelation.spouse:
        return localizations.spouse;
      case FamilyRelation.child:
        return localizations.child;
      case FamilyRelation.parent:
        return localizations.parent;
      case FamilyRelation.sibling:
        return localizations.sibling;
      case FamilyRelation.grandchild:
        return localizations.grandchild;
      case FamilyRelation.grandparent:
        return localizations.grandparent;
      case FamilyRelation.friend:
        return localizations.friend;
      case FamilyRelation.caregiver:
        return localizations.professionalCaregiver;
      case FamilyRelation.other:
        return localizations.other;
    }
  }

  Future<void> _sendInvitation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final familyService = Provider.of<FamilyService>(context, listen: false);
    final localizations = AppLocalizations.of(context)!;

    try {
      await familyService.inviteFamilyMember(
        email: _emailController.text.trim(),
        relation: _selectedRelation!,
        name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.invitationSent),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.failedToSendInvitation),
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