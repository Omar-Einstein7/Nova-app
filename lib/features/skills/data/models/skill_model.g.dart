// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SkillModel _$SkillModelFromJson(Map<String, dynamic> json) => _SkillModel(
      id: json['id'] as String,
      key: json['key'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SkillModelToJson(_SkillModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'description': instance.description,
    };
