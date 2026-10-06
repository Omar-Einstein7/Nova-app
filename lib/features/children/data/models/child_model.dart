import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/child.dart';

part 'child_model.freezed.dart';
part 'child_model.g.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

LearningStyle _learningStyleFromJson(String v) => switch (v) {
      'VISUAL' => LearningStyle.visual,
      'AUDITORY' => LearningStyle.auditory,
      _ => LearningStyle.mixed,
    };

String _learningStyleToJson(LearningStyle s) => switch (s) {
      LearningStyle.visual => 'VISUAL',
      LearningStyle.auditory => 'AUDITORY',
      LearningStyle.mixed => 'MIXED',
    };

SkillLevel _skillLevelFromJson(String v) => switch (v) {
      'INTERMEDIATE' => SkillLevel.intermediate,
      'ADVANCED' => SkillLevel.advanced,
      _ => SkillLevel.beginner,
    };

// ── ChildSkillModel ───────────────────────────────────────────────────────────

@freezed
abstract class ChildSkillModel with _$ChildSkillModel {
  const factory ChildSkillModel({
    required String skillId,
    required String key,
    @JsonKey(
      fromJson: _skillLevelFromJson,
      toJson: _skillLevelToString,
    )
    required SkillLevel level,
  }) = _ChildSkillModel;

  factory ChildSkillModel.fromJson(Map<String, dynamic> json) =>
      _$ChildSkillModelFromJson(json);
}

String _skillLevelToString(SkillLevel l) => l.name.toUpperCase();

extension ChildSkillModelX on ChildSkillModel {
  ChildSkill toDomain() => ChildSkill(skillId: skillId, key: key, level: level);
}

// ── ChildModel ────────────────────────────────────────────────────────────────

@freezed
abstract class ChildModel with _$ChildModel {
  const factory ChildModel({
    required String id,
    required String name,
    required int age,
    required List<String> interests,
    @JsonKey(
      fromJson: _learningStyleFromJson,
      toJson: _learningStyleToJson,
    )
    required LearningStyle learningStyle,
    @Default([]) List<ChildSkillModel> skills,
    String? avatar,
  }) = _ChildModel;

  factory ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);
}

extension ChildModelX on ChildModel {
  Child toDomain() => Child(
        id: id,
        name: name,
        age: age,
        interests: interests,
        learningStyle: learningStyle,
        skills: skills.map((s) => s.toDomain()).toList(),
        avatar: avatar,
      );
}
