import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/skill.dart';

part 'skills_state.freezed.dart';

@freezed
sealed class SkillsState with _$SkillsState {
  const factory SkillsState.initial() = SkillsStateInitial;
  const factory SkillsState.loading() = SkillsStateLoading;
  const factory SkillsState.loaded(List<Skill> skills) = SkillsStateLoaded;
  const factory SkillsState.error(Failure failure) = SkillsStateError;
}
