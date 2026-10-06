import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/skill.dart';
import '../../domain/usecases/get_skills_use_case.dart';
import 'skills_state.dart';

/// Session-scoped cubit: fetches once, caches in memory, exposes to the rest
/// of the feature tree via [BlocProvider] at app scope.
class SkillsCubit extends Cubit<SkillsState> {
  SkillsCubit({required GetSkillsUseCase getSkillsUseCase})
      : _getSkills = getSkillsUseCase,
        super(const SkillsState.initial());

  final GetSkillsUseCase _getSkills;

  /// Loads skills if not already loaded or loading.
  Future<void> load({bool forceRefresh = false}) async {
    if (!forceRefresh && state is SkillsStateLoaded) return;
    emit(const SkillsState.loading());
    final result = await _getSkills();
    result.fold(
      (failure) => emit(SkillsState.error(failure)),
      (skills) => emit(SkillsState.loaded(skills)),
    );
  }

  /// Convenience accessor for widgets that need the list immediately.
  List<Skill> get skills => switch (state) {
        SkillsStateLoaded(:final skills) => skills,
        _ => [],
      };
}
