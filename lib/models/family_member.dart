enum FamilyRelation {
  spouse,
  child,
  parent,
  sibling,
  grandchild,
  grandparent,
  friend,
  caregiver,
  other,
}

enum InvitationStatus {
  pending,
  accepted,
  rejected,
  expired,
}

class FamilyMember {
  final String id;
  final String userId;
  final String email;
  final String? name;
  final FamilyRelation relation;
  final InvitationStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final String? invitationToken;

  const FamilyMember({
    required this.id,
    required this.userId,
    required this.email,
    this.name,
    required this.relation,
    required this.status,
    required this.createdAt,
    this.respondedAt,
    this.invitationToken,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      relation: FamilyRelation.values.firstWhere(
        (e) => e.toString().split('.').last == json['relation'],
        orElse: () => FamilyRelation.other,
      ),
      status: InvitationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => InvitationStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      respondedAt: json['responded_at'] != null
          ? DateTime.parse(json['responded_at'] as String)
          : null,
      invitationToken: json['invitation_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email': email,
      'name': name,
      'relation': relation.toString().split('.').last,
      'status': status.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
      'invitation_token': invitationToken,
    };
  }

  FamilyMember copyWith({
    String? id,
    String? userId,
    String? email,
    String? name,
    FamilyRelation? relation,
    InvitationStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
    String? invitationToken,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
      invitationToken: invitationToken ?? this.invitationToken,
    );
  }
}