import 'package:equatable/equatable.dart';

import '../../domain/entities/activity.dart';
import '../../../../core/error/failures.dart';

/// All possible states of the activity player.
sealed class ActivityPlayerState extends Equatable {
  const ActivityPlayerState();
  @override
  List<Object?> get props => [];
}

/// Idle — nothing happening yet.
class ActivityPlayerIdle extends ActivityPlayerState {
  const ActivityPlayerIdle();
}

/// Generating the activity (long poll).
class ActivityPlayerGenerating extends ActivityPlayerState {
  const ActivityPlayerGenerating();
}

/// Activity generated; showing intro screen before first question.
class ActivityPlayerIntro extends ActivityPlayerState {
  const ActivityPlayerIntro(this.activity);
  final Activity activity;
  @override
  List<Object?> get props => [activity];
}

/// Starting a session (quick POST).
class ActivityPlayerStartingSession extends ActivityPlayerState {
  const ActivityPlayerStartingSession(this.activity);
  final Activity activity;
  @override
  List<Object?> get props => [activity];
}

/// A question is active and awaiting the child's answer.
class ActivityPlayerQuestionActive extends ActivityPlayerState {
  const ActivityPlayerQuestionActive({
    required this.activity,
    required this.sessionId,
    required this.questionIndex,
    required this.sessionStartMs,
    required this.questionStartMs,
    this.attemptNo = 0,
  });

  final Activity activity;
  final String sessionId;
  final int questionIndex;
  final int sessionStartMs;
  final int questionStartMs;

  /// How many times this question has been attempted so far (0 = first attempt).
  final int attemptNo;

  Question get currentQuestion => activity.questions[questionIndex];
  bool get isLastQuestion => questionIndex >= activity.questions.length - 1;

  @override
  List<Object?> get props => [
        activity,
        sessionId,
        questionIndex,
        sessionStartMs,
        questionStartMs,
        attemptNo,
      ];

  ActivityPlayerQuestionActive copyWith({int? attemptNo}) =>
      ActivityPlayerQuestionActive(
        activity: activity,
        sessionId: sessionId,
        questionIndex: questionIndex,
        sessionStartMs: sessionStartMs,
        questionStartMs: questionStartMs,
        attemptNo: attemptNo ?? this.attemptNo,
      );
}

/// Submitting an answer — brief loading during API call.
class ActivityPlayerSubmitting extends ActivityPlayerState {
  const ActivityPlayerSubmitting({
    required this.activity,
    required this.sessionId,
    required this.questionIndex,
    required this.sessionStartMs,
    required this.selectedAnswer,
  });

  final Activity activity;
  final String sessionId;
  final int questionIndex;
  final int sessionStartMs;
  final String selectedAnswer;

  @override
  List<Object?> get props => [
        activity,
        sessionId,
        questionIndex,
        sessionStartMs,
        selectedAnswer,
      ];
}

/// Showing answer feedback (correct / incorrect / max-attempts).
class ActivityPlayerAnswerFeedback extends ActivityPlayerState {
  const ActivityPlayerAnswerFeedback({
    required this.activity,
    required this.sessionId,
    required this.questionIndex,
    required this.sessionStartMs,
    required this.isCorrect,
    required this.feedbackText,
    required this.selectedAnswer,
    required this.attemptNo,
    required this.isMaxAttempts,
  });

  final Activity activity;
  final String sessionId;
  final int questionIndex;
  final int sessionStartMs;
  final bool isCorrect;
  final String feedbackText;
  final String selectedAnswer;
  final int attemptNo;

  /// True when attemptNo == 3 regardless of isCorrect → show next anyway.
  final bool isMaxAttempts;

  bool get isLastQuestion => questionIndex >= activity.questions.length - 1;
  bool get canProceed => isCorrect || isMaxAttempts;

  @override
  List<Object?> get props => [
        activity,
        sessionId,
        questionIndex,
        sessionStartMs,
        isCorrect,
        feedbackText,
        selectedAnswer,
        attemptNo,
        isMaxAttempts,
      ];
}

/// All questions done; completing session (quick POST).
class ActivityPlayerCompleting extends ActivityPlayerState {
  const ActivityPlayerCompleting();
}

/// Session completed; result ready.
class ActivityPlayerResult extends ActivityPlayerState {
  const ActivityPlayerResult({
    required this.result,
    required this.childId,
  });

  final SessionResult result;
  final String childId;

  @override
  List<Object?> get props => [result, childId];
}

/// Unrecoverable error (generate or session start failed).
class ActivityPlayerError extends ActivityPlayerState {
  const ActivityPlayerError(this.failure);
  final Failure failure;
  @override
  List<Object?> get props => [failure];
}
