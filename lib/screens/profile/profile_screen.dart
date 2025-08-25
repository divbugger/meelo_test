import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meelo/services/auth_service.dart';
import 'package:meelo/services/language_service.dart';
import 'package:meelo/services/family_service.dart';
import 'package:meelo/services/figure_status_service.dart';
import 'package:meelo/services/notification_service.dart';
import 'package:meelo/screens/profile/user_edit_screen.dart';
import 'package:meelo/screens/profile/family_member_form.dart';
import 'package:meelo/screens/profile/figure_connection_screen.dart';
import 'package:meelo/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final familyService = Provider.of<FamilyService>(context, listen: false);
      final figureStatusService = Provider.of<FigureStatusService>(context, listen: false);
      final notificationService = Provider.of<NotificationService>(context, listen: false);
      
      familyService.loadFamilyMembers();
      figureStatusService.loadFigureStatuses();
      notificationService.loadUserPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                _buildProfileHeader(context, authService, localizations),
                
                const SizedBox(height: 32),
                
                // User Section
                _buildUserSection(context, authService, localizations),
                
                const SizedBox(height: 24),
                
                // Family Members Section
                _buildFamilyMembersSection(context, localizations),
                
                const SizedBox(height: 24),
                
                // Figures Section
                _buildFiguresSection(context, localizations),
                
                const SizedBox(height: 24),
                
                // Others Section
                _buildOthersSection(context, authService, localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthService authService, AppLocalizations localizations) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF483FA9),
                child: const Icon(
                  Icons.person,
                  size: 50,
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
                      Icons.edit,
                      color: const Color(0xFF483FA9),
                      size: 18,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UserEditScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            authService.userProfile?['name'] ?? 'User',
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF040506),
            ),
          ),
          if (authService.userProfile?['nickname'] != null) ...[
            const SizedBox(height: 4),
            Text(
              '\"${authService.userProfile!['nickname']}\"',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            authService.currentUser?.email ?? '',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, AuthService authService, AppLocalizations localizations) {
    return _buildSection(
      title: localizations.user,
      icon: Icons.person_outline,
      children: [
        _buildListTile(
          icon: Icons.edit_outlined,
          title: localizations.editProfile,
          subtitle: 'Update your name and nickname',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserEditScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFamilyMembersSection(BuildContext context, AppLocalizations localizations) {
    return Consumer<FamilyService>(
      builder: (context, familyService, child) {
        final acceptedMembers = familyService.getAcceptedFamilyMembers();
        final pendingInvitations = familyService.getPendingInvitations();
        
        return _buildSection(
          title: localizations.familyMembers,
          icon: Icons.family_restroom,
          trailing: IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF483FA9)),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FamilyMemberForm(),
                ),
              );
            },
          ),
          children: [
            if (acceptedMembers.isEmpty && pendingInvitations.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  localizations.noFamilyMembers,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            else ...[
              ...acceptedMembers.map((member) => _buildFamilyMemberTile(member, localizations)),
              ...pendingInvitations.map((member) => _buildFamilyMemberTile(member, localizations)),
            ],
            _buildListTile(
              icon: Icons.person_add_outlined,
              title: localizations.addFamilyMember,
              subtitle: 'Send invitation via email',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FamilyMemberForm(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildFiguresSection(BuildContext context, AppLocalizations localizations) {
    return Consumer<FigureStatusService>(
      builder: (context, figureStatusService, child) {
        final connectedCount = figureStatusService.getConnectedCount();
        
        return _buildSection(
          title: localizations.figures,
          icon: Icons.devices_outlined,
          children: [
            _buildListTile(
              icon: Icons.settings_input_component,
              title: localizations.boxConnectionStatus,
              subtitle: connectedCount == 0 
                  ? localizations.noFiguresConnectedToBox
                  : '$connectedCount of 3 ${localizations.figuresConnectedToBox}',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FigureConnectionScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOthersSection(BuildContext context, AuthService authService, AppLocalizations localizations) {
    return _buildSection(
      title: localizations.others,
      icon: Icons.more_horiz,
      children: [
        // Notifications
        Consumer<NotificationService>(
          builder: (context, notificationService, child) {
            return _buildListTile(
              icon: Icons.notifications_outlined,
              title: localizations.notifications,
              subtitle: 'Manage your notification preferences',
              trailing: Switch(
                value: notificationService.notificationSettings?.generalNotificationsEnabled ?? true,
                onChanged: (value) {
                  notificationService.updateGeneralNotifications(value);
                },
                activeColor: const Color(0xFF483FA9),
              ),
              onTap: () => _showNotificationSettings(context, notificationService, localizations),
            );
          },
        ),
        
        // Language
        Consumer<LanguageService>(
          builder: (context, languageService, child) {
            return _buildListTile(
              icon: Icons.language,
              title: localizations.language,
              subtitle: languageService.currentLocale.languageCode == 'en' ? 'English' : 'Deutsch',
              onTap: () => _showLanguageSelector(context, languageService, localizations),
            );
          },
        ),
        
        // Feedback
        _buildListTile(
          icon: Icons.feedback_outlined,
          title: localizations.giveFeedback,
          subtitle: 'Share your thoughts with us',
          onTap: () => _sendFeedbackEmail(localizations),
        ),
        
        // Help
        _buildListTile(
          icon: Icons.help_outline,
          title: localizations.help,
          subtitle: 'Get help and support',
          onTap: () {
            // TODO: Implement help section
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help section coming soon')),
            );
          },
        ),
        
        // Privacy
        _buildListTile(
          icon: Icons.privacy_tip_outlined,
          title: localizations.privacy,
          subtitle: 'Data privacy guidelines',
          onTap: () {
            // TODO: Implement privacy guidelines
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy guidelines coming soon')),
            );
          },
        ),
        
        // Imprint
        _buildListTile(
          icon: Icons.info_outline,
          title: localizations.imprint,
          subtitle: 'Legal information',
          onTap: () {
            // TODO: Implement imprint
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Imprint coming soon')),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Sign Out Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showSignOutDialog(context, authService, localizations),
            icon: const Icon(Icons.logout, size: 18),
            label: Text(localizations.signOut),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Delete Account Button
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => _showDeleteAccountDialog(context, authService, localizations),
            icon: const Icon(Icons.delete_forever, size: 18, color: Colors.red),
            label: Text(
              localizations.deleteAccount,
              style: const TextStyle(color: Colors.red),
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    Widget? trailing,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF483FA9),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF040506),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF040506),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ] else if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMemberTile(dynamic member, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF483FA9).withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: const Color(0xFF483FA9),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name ?? member.email,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF040506),
                  ),
                ),
                Text(
                  '${_getRelationDisplayName(member.relation, localizations)} • ${_getStatusDisplayName(member.status, localizations)}',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (member.status.toString().split('.').last == 'pending')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                localizations.pendingInvitation,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getRelationDisplayName(dynamic relation, AppLocalizations localizations) {
    final relationStr = relation.toString().split('.').last;
    switch (relationStr) {
      case 'spouse':
        return localizations.spouse;
      case 'child':
        return localizations.child;
      case 'parent':
        return localizations.parent;
      case 'sibling':
        return localizations.sibling;
      case 'grandchild':
        return localizations.grandchild;
      case 'grandparent':
        return localizations.grandparent;
      case 'friend':
        return localizations.friend;
      case 'caregiver':
        return localizations.professionalCaregiver;
      case 'other':
        return localizations.other;
      default:
        return relationStr;
    }
  }

  String _getStatusDisplayName(dynamic status, AppLocalizations localizations) {
    final statusStr = status.toString().split('.').last;
    switch (statusStr) {
      case 'accepted':
        return localizations.accepted;
      case 'rejected':
        return localizations.rejected;
      case 'pending':
        return localizations.pendingInvitation;
      case 'expired':
        return localizations.expired;
      default:
        return statusStr;
    }
  }

  void _showNotificationSettings(BuildContext context, dynamic notificationService, AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.notificationSettings,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF040506),
              ),
            ),
            const SizedBox(height: 24),
            _buildNotificationToggle(
              localizations.storyNotifications,
              notificationService.notificationSettings?.storiesEnabled ?? true,
              (value) => notificationService.updateStoriesNotification(value),
            ),
            _buildNotificationToggle(
              localizations.familyUpdateNotifications,
              notificationService.notificationSettings?.familyUpdatesEnabled ?? true,
              (value) => notificationService.updateFamilyUpdatesNotification(value),
            ),
            _buildNotificationToggle(
              localizations.reminderNotifications,
              notificationService.notificationSettings?.remindersEnabled ?? true,
              (value) => notificationService.updateRemindersNotification(value),
            ),
            _buildNotificationToggle(
              localizations.generalNotifications,
              notificationService.notificationSettings?.generalNotificationsEnabled ?? true,
              (value) => notificationService.updateGeneralNotifications(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                color: Color(0xFF040506),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF483FA9),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, LanguageService languageService, AppLocalizations localizations) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.selectLanguage,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF040506),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    'English',
                    'en',
                    languageService.currentLocale.languageCode == 'en',
                    languageService,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    'Deutsch',
                    'de',
                    languageService.currentLocale.languageCode == 'de',
                    languageService,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    String languageCode,
    bool isSelected,
    LanguageService languageService,
  ) {
    return GestureDetector(
      onTap: () {
        languageService.setLanguage(languageCode);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF483FA9) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF483FA9) : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 16,
              ),
            if (isSelected) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendFeedbackEmail(AppLocalizations localizations) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'divya.tyagi@idememory.de',
      query: _encodeQueryParameters(<String, String>{
        'subject': localizations.feedbackEmailSubject,
        'body': localizations.feedbackEmailBody,
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw Exception('Could not launch email client');
      }
    } catch (e) {
      // Fallback: show email address to copy
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text(localizations.giveFeedback),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please send your feedback to:'),
              const SizedBox(height: 8),
              SelectableText(
                'divya.tyagi@idememory.de',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF483FA9),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  void _showSignOutDialog(BuildContext context, AuthService authService, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(localizations.signOut),
        content: Text(localizations.signOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              authService.signOut();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(localizations.signOut),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthService authService, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(localizations.deleteAccount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.deleteAccountWarning),
            const SizedBox(height: 16),
            Text(localizations.deleteAccountConfirmation),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion feature coming soon'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(localizations.delete),
          ),
        ],
      ),
    );
  }
}