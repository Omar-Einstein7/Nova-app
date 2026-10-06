import '../../../../core/error/failures.dart';
import '../../domain/entities/child.dart';

enum ChildFormStatus { idle, loading, success, failure }

/// Immutable state for the 3-step child form.
class ChildFormState {
  const ChildFormState({
    this.existingId,
    this.currentStep = 0,
    this.name = '',
    this.birthDate,
    this.avatar,
    this.interests = const [],
    this.learningStyle,
    this.selectedSkillIds = const [],
    this.status = ChildFormStatus.idle,
    this.failure,
    this.savedChild,
  });

  /// Non-null when editing an existing child.
  final String? existingId;

  final int currentStep;

  // Step 1
  final String name;
  final DateTime? birthDate;
  final String? avatar;

  // Step 2
  final List<String> interests;
  final LearningStyle? learningStyle;

  // Step 3
  final List<String> selectedSkillIds;

  // Submission
  final ChildFormStatus status;
  final Failure? failure;
  final Child? savedChild;

  ChildFormState copyWith({
    String? existingId,
    int? currentStep,
    String? name,
    DateTime? birthDate,
    String? avatar,
    List<String>? interests,
    LearningStyle? learningStyle,
    List<String>? selectedSkillIds,
    ChildFormStatus? status,
    Failure? failure,
    Child? savedChild,
  }) =>
      ChildFormState(
        existingId: existingId ?? this.existingId,
        currentStep: currentStep ?? this.currentStep,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        avatar: avatar ?? this.avatar,
        interests: interests ?? this.interests,
        learningStyle: learningStyle ?? this.learningStyle,
        selectedSkillIds: selectedSkillIds ?? this.selectedSkillIds,
        status: status ?? this.status,
        failure: failure, // allow explicit null-clear
        savedChild: savedChild, // allow explicit null-clear
      );
}
