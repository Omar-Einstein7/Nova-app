import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' as fp;

import '../../../../core/error/failures.dart';
import '../../domain/entities/child.dart';
import '../../domain/usecases/children_use_cases.dart';
import 'child_form_state.dart';

/// Cubit for the 3-step ChildFormPage.
/// Created as a factory (not singleton) — one instance per form session.
class ChildFormCubit extends Cubit<ChildFormState> {
  ChildFormCubit({
    required CreateChildUseCase createChild,
    required UpdateChildUseCase updateChild,
    Child? existing,
  })  : _create = createChild,
        _update = updateChild,
        super(_buildInitialState(existing));

  final CreateChildUseCase _create;
  final UpdateChildUseCase _update;

  bool get isEditMode => state.existingId != null;

  int? get currentAge =>
      state.birthDate == null ? null : _calcAge(state.birthDate!);

  // ── Step navigation ───────────────────────────────────────────────────────

  void nextStep() {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      emit(state.copyWith(currentStep: step));
    }
  }

  // ── Step 1 fields ─────────────────────────────────────────────────────────

  void setName(String name) => emit(state.copyWith(name: name));

  void setBirthDate(DateTime date) => emit(state.copyWith(birthDate: date));

  void setAvatar(String avatar) => emit(state.copyWith(avatar: avatar));

  // ── Step 2 fields ─────────────────────────────────────────────────────────

  void toggleInterest(String interest) {
    final current = List<String>.from(state.interests);
    if (current.contains(interest)) {
      current.remove(interest);
    } else if (current.length < 10) {
      current.add(interest);
    }
    emit(state.copyWith(interests: current));
  }

  void addCustomInterest(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty || state.interests.contains(trimmed)) return;
    if (state.interests.length >= 10) return;
    emit(state.copyWith(interests: [...state.interests, trimmed]));
  }

  void setLearningStyle(LearningStyle style) =>
      emit(state.copyWith(learningStyle: style));

  // ── Step 3 fields ─────────────────────────────────────────────────────────

  void toggleSkill(String skillId) {
    final current = List<String>.from(state.selectedSkillIds);
    if (current.contains(skillId)) {
      current.remove(skillId);
    } else {
      current.add(skillId);
    }
    emit(state.copyWith(selectedSkillIds: current));
  }

  // ── Validation guards ─────────────────────────────────────────────────────

  bool validateStep1() {
    final name = state.name.trim();
    if (name.isEmpty || name.length > 40) return false;
    if (state.birthDate == null) return false;
    final age = _calcAge(state.birthDate!);
    return age >= 3 && age <= 18;
  }

  bool validateStep2() => state.learningStyle != null;

  bool validateStep3() => state.selectedSkillIds.isNotEmpty;

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> submit() async {
    if (!validateStep1() || !validateStep2() || !validateStep3()) return;

    emit(state.copyWith(status: ChildFormStatus.loading, failure: null));

    final fp.Either<Failure, Child> result;

    if (isEditMode) {
      result = await _update(
        id: state.existingId!,
        name: state.name.trim(),
        birthDate: state.birthDate!,
        interests: state.interests,
        learningStyle: state.learningStyle!,
        skillIds: state.selectedSkillIds,
        avatar: state.avatar,
      );
    } else {
      result = await _create(
        name: state.name.trim(),
        birthDate: state.birthDate!,
        interests: state.interests,
        learningStyle: state.learningStyle!,
        skillIds: state.selectedSkillIds,
        avatar: state.avatar,
      );
    }

    result.fold(
      (f) => emit(state.copyWith(status: ChildFormStatus.failure, failure: f)),
      (child) => emit(
          state.copyWith(status: ChildFormStatus.success, savedChild: child)),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static int _calcAge(DateTime birth) {
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  static ChildFormState _buildInitialState(Child? existing) {
    if (existing == null) return const ChildFormState();
    return ChildFormState(
      existingId: existing.id,
      name: existing.name,
      birthDate: _birthFromAge(existing.age),
      interests: existing.interests,
      learningStyle: existing.learningStyle,
      selectedSkillIds: existing.skills.map((s) => s.skillId).toList(),
      avatar: existing.avatar,
    );
  }

  static DateTime _birthFromAge(int age) {
    final now = DateTime.now();
    return DateTime(now.year - age, now.month, now.day);
  }
}

/// Factory registered in GetIt so ChildFormPage can instantiate a fresh cubit
/// with optional existing child for editing.
class ChildFormCubitFactory {
  const ChildFormCubitFactory({
    required CreateChildUseCase createChild,
    required UpdateChildUseCase updateChild,
  })  : _createChild = createChild,
        _updateChild = updateChild;

  final CreateChildUseCase _createChild;
  final UpdateChildUseCase _updateChild;

  ChildFormCubit create(Child? existing) => ChildFormCubit(
        createChild: _createChild,
        updateChild: _updateChild,
        existing: existing,
      );
}
