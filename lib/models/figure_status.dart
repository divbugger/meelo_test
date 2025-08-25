enum FigureType {
  lifeStory,
  familyAndFriends,
  music,
}

class FigureStatus {
  final String id;
  final String userId;
  final FigureType figureType;
  final bool isConnected;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FigureStatus({
    required this.id,
    required this.userId,
    required this.figureType,
    required this.isConnected,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FigureStatus.fromJson(Map<String, dynamic> json) {
    return FigureStatus(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      figureType: FigureType.values.firstWhere(
        (e) => e.toString().split('.').last == json['figure_type'],
        orElse: () => FigureType.lifeStory,
      ),
      isConnected: json['is_connected'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'figure_type': figureType.toString().split('.').last,
      'is_connected': isConnected,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FigureStatus copyWith({
    String? id,
    String? userId,
    FigureType? figureType,
    bool? isConnected,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FigureStatus(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      figureType: figureType ?? this.figureType,
      isConnected: isConnected ?? this.isConnected,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FigureStatus &&
        other.id == id &&
        other.userId == userId &&
        other.figureType == figureType &&
        other.isConnected == isConnected;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        figureType.hashCode ^
        isConnected.hashCode;
  }

  @override
  String toString() {
    return 'FigureStatus(id: $id, figureType: $figureType, isConnected: $isConnected)';
  }
}