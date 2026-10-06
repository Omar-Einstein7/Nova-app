import 'package:equatable/equatable.dart';

/// Events that drive the [ActivityPlayerBloc].
sealed class ActivityPlayerEvent extends Equatable {
  const ActivityPlayerEvent();
  @override
  List<Object?> get props => [];
}

/// Start: generate an activity for [childId].
class ActivityStartRequested extends ActivityPlayerEvent {
  const ActivityStartRequested({
    required this.childId,
    this.skillId,
    this.difficulty,
  });

  final String childId;
  final String? skillId;
  final String? difficulty;

  @override
  List<Object?> get props => [childId, skillId, difficulty];
}

/// Child tapped "ابدأ" on the intro screen → start a session.
class ActivityIntroConfirmed extends ActivityPlayerEvent {
  const ActivityIntroConfirmed();
}

/// Child selected an answer option.
class ActivityAnswerSelected extends ActivityPlayerEvent {
  const ActivityAnswerSelected(this.answer);
  final String answer;
  @override
  List<Object?> get props => [answer];
}

/// Child (or auto-advance) tapped "التالي" after feedback.
class ActivityNextQuestion extends ActivityPlayerEvent {
  const ActivityNextQuestion();
}

/// All questions done → complete the session.
class ActivitySessionCompleteRequested extends ActivityPlayerEvent {
  const ActivitySessionCompleteRequested();
}

/// User retried after an error.
class ActivityRetryRequested extends ActivityPlayerEvent {
  const ActivityRetryRequested();
}

/// User exits the activity (after passing ParentGate).
class ActivityExitRequested extends ActivityPlayerEvent {
  const ActivityExitRequested();
}

/// Reset question state to try again after non-fatal incorrect answer.
class ActivityRetryCurrentQuestion extends ActivityPlayerEvent {
  const ActivityRetryCurrentQuestion();
}
