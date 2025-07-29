import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? name;
  final int? age;
  final List<String> interests;
  final bool isOnboarded;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.age,
    this.interests = const [],
    this.isOnboarded = false,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    int? age,
    List<String>? interests,
    bool? isOnboarded,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      interests: interests ?? this.interests,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

class InterestCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Color color;

  const InterestCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class Color {
  final int value;
  const Color(this.value);
}

class InterestCategories {
  static const List<InterestCategory> all = [
    InterestCategory(
      id: 'chess',
      name: 'Chess',
      description: 'Strategic thinking and tactical puzzles',
      icon: '♔',
      color: Color(0xFF4ECDC4),
    ),
    InterestCategory(
      id: 'math',
      name: 'Mathematics',
      description: 'Numbers, patterns, and problem solving',
      icon: '🧮',
      color: Color(0xFF45B7D1),
    ),
    InterestCategory(
      id: 'programming',
      name: 'Programming',
      description: 'Coding challenges and CS concepts',
      icon: '💻',
      color: Color(0xFF96CEB4),
    ),
    InterestCategory(
      id: 'science',
      name: 'Science',
      description: 'Fascinating facts and discoveries',
      icon: '🔬',
      color: Color(0xFFFF6B6B),
    ),
    InterestCategory(
      id: 'mindfulness',
      name: 'Mindfulness',
      description: 'Mental wellness and relaxation',
      icon: '🧘',
      color: Color(0xFFDDA0DD),
    ),
    InterestCategory(
      id: 'history',
      name: 'History',
      description: 'Stories from the past',
      icon: '📚',
      color: Color(0xFFF7DC6F),
    ),
    InterestCategory(
      id: 'geography',
      name: 'Geography',
      description: 'World cultures and places',
      icon: '🌍',
      color: Color(0xFF98D8C8),
    ),
    InterestCategory(
      id: 'art',
      name: 'Art & Design',
      description: 'Creativity and visual expression',
      icon: '🎨',
      color: Color(0xFFE74C3C),
    ),
    InterestCategory(
      id: 'music',
      name: 'Music',
      description: 'Rhythm, theory, and composition',
      icon: '🎵',
      color: Color(0xFF9B59B6),
    ),
    InterestCategory(
      id: 'literature',
      name: 'Literature',
      description: 'Stories, poetry, and language',
      icon: '📖',
      color: Color(0xFF3498DB),
    ),
  ];
} 