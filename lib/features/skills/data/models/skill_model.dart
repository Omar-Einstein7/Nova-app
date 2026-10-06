import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/skill.dart';

part 'skill_model.freezed.dart';
part 'skill_model.g.dart';

@freezed
abstract class SkillModel with _$SkillModel {
  const factory SkillModel({
    required String id,
    required String key,
    required String nameAr,
    required String nameEn,
    String? description,
  }) = _SkillModel;

  factory SkillModel.fromJson(Map<String, dynamic> json) =>
      _$SkillModelFromJson(json);
}

extension SkillModelX on SkillModel {
  Skill toDomain() => Skill(
        id: id,
        key: key,
        nameAr: nameAr,
        nameEn: nameEn,
        description: description,
      );
}
