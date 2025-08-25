import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:meelo/models/family_member.dart';

class FamilyService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();
  
  List<FamilyMember> _familyMembers = [];
  bool _isLoading = false;

  List<FamilyMember> get familyMembers => List.unmodifiable(_familyMembers);
  bool get isLoading => _isLoading;

  Future<void> loadFamilyMembers() async {
    if (_supabase.auth.currentUser == null) return;

    _setLoading(true);
    try {
      final response = await _supabase
          .from('family_connections')
          .select()
          .eq('user_id', _supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      _familyMembers = (response as List)
          .map((json) => FamilyMember.fromJson(json))
          .toList();
      
      notifyListeners();
    } catch (error) {
      debugPrint('Error loading family members: $error');
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> inviteFamilyMember({
    required String email,
    required FamilyRelation relation,
    String? name,
  }) async {
    // Validation
    if (_supabase.auth.currentUser == null) {
      throw Exception('User not authenticated');
    }

    if (email.trim().isEmpty) {
      throw Exception('Email address is required');
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      throw Exception('Please enter a valid email address');
    }

    if (name != null && name.trim().length > 100) {
      throw Exception('Name must be less than 100 characters');
    }

    // Check if family member already exists
    final existingMembers = _familyMembers.where((member) => 
        member.email.toLowerCase() == email.trim().toLowerCase()).toList();
    final existingMember = existingMembers.isNotEmpty ? existingMembers.first : null;
    
    if (existingMember != null) {
      if (existingMember.status == InvitationStatus.accepted) {
        throw Exception('This person is already a family member');
      } else if (existingMember.status == InvitationStatus.pending) {
        throw Exception('An invitation has already been sent to this email address');
      }
    }

    try {
      final invitationToken = _uuid.v4();
      final familyMember = FamilyMember(
        id: _uuid.v4(),
        userId: _supabase.auth.currentUser!.id,
        email: email.trim().toLowerCase(),
        name: name?.trim(),
        relation: relation,
        status: InvitationStatus.pending,
        createdAt: DateTime.now(),
        invitationToken: invitationToken,
      );

      final response = await _supabase
          .from('family_connections')
          .insert(familyMember.toJson())
          .select()
          .single();

      if (response == null) {
        throw Exception('Failed to create family connection');
      }

      try {
        await _sendInvitationEmail(familyMember);
      } catch (emailError) {
        // If email fails, remove the database entry
        await _supabase
            .from('family_connections')
            .delete()
            .eq('id', familyMember.id);
        
        debugPrint('Email sending failed: $emailError');
        throw Exception('Failed to send invitation email. Please check the email address and try again.');
      }

      _familyMembers.insert(0, familyMember);
      notifyListeners();

      return familyMember.id;
    } catch (error) {
      debugPrint('Error inviting family member: $error');
      
      if (error.toString().contains('duplicate key')) {
        throw Exception('An invitation has already been sent to this email address');
      } else if (error.toString().contains('network')) {
        throw Exception('Network error. Please check your internet connection and try again.');
      } else if (error is Exception) {
        rethrow;
      } else {
        throw Exception('Failed to send invitation. Please try again.');
      }
    }
  }

  Future<void> _sendInvitationEmail(FamilyMember familyMember) async {
    try {
      final userProfile = await _supabase
          .from('profiles')
          .select('name')
          .eq('id', familyMember.userId)
          .single();

      final inviterName = userProfile['name'] ?? 'A family member';
      final relationText = _getRelationDisplayText(familyMember.relation);
      
      final invitationLink = 'meelo://family/invitation?token=${familyMember.invitationToken}';
      
      final emailBody = '''
Dear ${familyMember.name ?? 'friend'},

$inviterName has invited you to connect as their $relationText on meelo, the memory-sharing app for families dealing with dementia.

Click the link below to accept this invitation:
$invitationLink

Or copy and paste this link into your browser.

Best regards,
The meelo Team
''';

      await _supabase.functions.invoke(
        'send-email',
        body: {
          'to': familyMember.email,
          'subject': 'Family Invitation from $inviterName - meelo App',
          'text': emailBody,
        },
      );
    } catch (error) {
      debugPrint('Error sending invitation email: $error');
    }
  }

  Future<bool> respondToInvitation({
    required String token,
    required bool accept,
  }) async {
    // Validation
    if (token.trim().isEmpty) {
      throw Exception('Invalid invitation token');
    }

    if (_supabase.auth.currentUser == null) {
      throw Exception('User not authenticated');
    }

    try {
      // First, verify the invitation exists and is valid
      final invitation = await _supabase
          .from('family_connections')
          .select()
          .eq('invitation_token', token)
          .eq('status', 'pending')
          .maybeSingle();

      if (invitation == null) {
        throw Exception('Invitation not found or has already been responded to');
      }

      // Check if invitation has expired (30 days)
      final createdAt = DateTime.parse(invitation['created_at']);
      final isExpired = DateTime.now().difference(createdAt).inDays > 30;
      
      if (isExpired) {
        // Mark as expired
        await _supabase
            .from('family_connections')
            .update({
              'status': 'expired',
              'responded_at': DateTime.now().toIso8601String(),
            })
            .eq('invitation_token', token);
        
        throw Exception('This invitation has expired. Please ask for a new invitation.');
      }

      final status = accept ? InvitationStatus.accepted : InvitationStatus.rejected;
      
      final response = await _supabase
          .from('family_connections')
          .update({
            'status': status.toString().split('.').last,
            'responded_at': DateTime.now().toIso8601String(),
          })
          .eq('invitation_token', token)
          .select();

      if (response.isEmpty) {
        throw Exception('Failed to update invitation status');
      }

      await loadFamilyMembers();
      return true;
    } catch (error) {
      debugPrint('Error responding to invitation: $error');
      
      if (error is Exception) {
        rethrow;
      } else if (error.toString().contains('network')) {
        throw Exception('Network error. Please check your internet connection and try again.');
      } else {
        throw Exception('Failed to respond to invitation. Please try again.');
      }
    }
  }

  Future<bool> removeFamilyMember(String familyMemberId) async {
    try {
      await _supabase
          .from('family_connections')
          .delete()
          .eq('id', familyMemberId);

      _familyMembers.removeWhere((member) => member.id == familyMemberId);
      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('Error removing family member: $error');
      return false;
    }
  }

  Future<bool> updateFamilyMember(FamilyMember updatedMember) async {
    try {
      await _supabase
          .from('family_connections')
          .update(updatedMember.toJson())
          .eq('id', updatedMember.id);

      final index = _familyMembers.indexWhere((member) => member.id == updatedMember.id);
      if (index != -1) {
        _familyMembers[index] = updatedMember;
        notifyListeners();
      }
      return true;
    } catch (error) {
      debugPrint('Error updating family member: $error');
      return false;
    }
  }

  List<FamilyMember> getAcceptedFamilyMembers() {
    return _familyMembers.where((member) => member.status == InvitationStatus.accepted).toList();
  }

  List<FamilyMember> getPendingInvitations() {
    return _familyMembers.where((member) => member.status == InvitationStatus.pending).toList();
  }

  String _getRelationDisplayText(FamilyRelation relation) {
    switch (relation) {
      case FamilyRelation.spouse:
        return 'spouse';
      case FamilyRelation.child:
        return 'child';
      case FamilyRelation.parent:
        return 'parent';
      case FamilyRelation.sibling:
        return 'sibling';
      case FamilyRelation.grandchild:
        return 'grandchild';
      case FamilyRelation.grandparent:
        return 'grandparent';
      case FamilyRelation.friend:
        return 'friend';
      case FamilyRelation.caregiver:
        return 'caregiver';
      case FamilyRelation.other:
        return 'family member';
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}