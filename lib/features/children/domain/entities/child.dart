import 'package:equatable/equatable.dart';

/// Learning style options supported by the backend.
enum LearningStyle { visual, auditory, mixed }

/// Skill level for a child's skill entry.
enum SkillLevel { beginner, intermediate, advanced }

/// A skill assigned to a child, with their current level.
class ChildSkill extends Equatable {
  const ChildSkill({
    required this.skillId,
    required this.key,
    required this.level,
  });

  final String skillId;
  final String key;
  final SkillLevel level;

  @override
  List<Object?> get props => [skillId, key, level];
}

/// Core child entity.
class Child extends Equatable {
  const Child({
    required this.id,
    required this.name,
    required this.age,
    required this.interests,
    required this.learningStyle,
    required this.skills,
    this.avatar,
  });

  final String id;
  final String name;
  final int age;
  final List<String> interests;
  final LearningStyle learningStyle;
  final List<ChildSkill> skills;

  /// [PLACEHOLDER: avatar identifier — matches an asset in assets/avatars/]
  final String? avatar;

  @override
  List<Object?> get props =>
      [id, name, age, interests, learningStyle, skills, avatar];
}
