// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChildSkillModel _$ChildSkillModelFromJson(Map<String, dynamic> json) =>
    _ChildSkillModel(
      skillId: json['skillId'] as String,
      key: json['key'] as String,
      level: _skillLevelFromJson(json['level'] as String),
    );

Map<String, dynamic> _$ChildSkillModelToJson(_ChildSkillModel instance) =>
    <String, dynamic>{
      'skillId': instance.skillId,
      'key': instance.key,
      'level': _skillLevelToString(instance.level),
    };

_ChildModel _$ChildModelFromJson(Map<String, dynamic> json) => _ChildModel(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      learningStyle: _learningStyleFromJson(json['learningStyle'] as String),
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => ChildSkillModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$ChildModelToJson(_ChildModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'interests': instance.interests,
      'learningStyle': _learningStyleToJson(instance.learningStyle),
      'skills': instance.skills,
      'avatar': instance.avatar,
    };
