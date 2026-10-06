import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/activity_use_cases.dart';
import 'activity_player_event.dart';
import 'activity_player_state.dart';

/// Drives the full activity play flow.
/// Max 3 attempts per question; after the 3rd failed attempt the bloc
/// marks isMaxAttempts=true so the UI shows "التالي" regardless.
class ActivityPlayerBloc
    extends Bloc<ActivityPlayerEvent, ActivityPlayerState> {
  ActivityPlayerBloc({
    required this.generateActivity,
    required this.startSession,
    required this.submitAnswer,
    required this.completeSession,
  }) : super(const ActivityPlayerIdle()) {
    on<ActivityStartRequested>(_onStartRequested);
    on<ActivityIntroConfirmed>(_onIntroConfirmed);
    on<ActivityAnswerSelected>(_onAnswerSelected);
    on<ActivityNextQuestion>(_onNextQuestion);
    on<ActivitySessionCompleteRequested>(_onCompleteRequested);
    on<ActivityRetryRequested>(_onRetryRequested);
    on<ActivityExitRequested>(_onExitRequested);
    on<ActivityRetryCurrentQuestion>(_onRetryCurrentQuestion);
  }

  final GenerateActivityUseCase generateActivity;
  final StartSessionUseCase startSession;
  final SubmitAnswerUseCase submitAnswer;
  final CompleteSessionUseCase completeSession;

  // Store childId so retry can re-use it
  String? _childId;
  String? _skillId;
  String? _difficulty;

  // ── Handlers ───────────────────────────────────────────────────────────────

  Future<void> _onStartRequested(
    ActivityStartRequested event,
    Emitter<ActivityPlayerState> emit,
  ) async {
    _childId = event.childId;
    _skillId = event.skillId;
    _difficulty = event.difficulty;

    emit(const ActivityPlayerGenerating());

    final result = await generateActivity(
      event.childId,
      skillId: event.skillId,
      difficulty: event.difficulty,
    );

    result.fold(
      (failure) => emit(ActivityPlayerError(failure)),
      (activity) => emit(ActivityPlayerIntro(activity)),
    );
  }

  Future<void> _onIntroConfirmed(
    ActivityIntroConfirmed event,
    Emitter<ActivityPlayerState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ActivityPlayerIntro) return;

    emit(ActivityPlayerStartingSession(currentState.activity));

    final result = await startSession(currentState.activity.id);

    result.fold(
      (failure) => emit(ActivityPlayerError(failure)),
      (session) {
        final now = DateTime.now().millisecondsSinceEpoch;
        emit(ActivityPlayerQuestionActive(
          activity: currentState.activity,
          sessionId: session.sessionId,
          questionIndex: 0,
          sessionStartMs: now,
          questionStartMs: now,
        ));
      },
    );
  }

  Future<void> _onAnswerSelected(
    ActivityAnswerSelected event,
    Emitter<ActivityPlayerState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ActivityPlayerQuestionActive) return;

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final timeMs = nowMs - currentState.questionStartMs;

    emit(ActivityPlayerSubmitting(
      activity: currentState.activity,
      sessionId: currentState.sessionId,
      questionIndex: currentState.questionIndex,
      sessionStartMs: currentState.sessionStartMs,
      selectedAnswer: event.answer,
    ));

    final result = await submitAnswer(
      currentState.sessionId,
      questionIndex: currentState.questionIndex,
      selectedAnswer: event.answer,
      timeMs: timeMs,
      usedHelp: false,
    );

    result.fold(
      (failure) => emit(ActivityPlayerError(failure)),
      (answerResult) {
        final isMaxAttempts = answerResult.attemptNo >= 3;
        emit(ActivityPlayerAnswerFeedback(
          activity: currentState.activity,
          sessionId: currentState.sessionId,
          questionIndex: currentState.questionIndex,
          sessionStartMs: currentState.sessionStartMs,
          isCorrect: answerResult.isCorrect,
          feedbackText: answerResult.feedback,
          selectedAnswer: event.answer,
          attemptNo: answerResult.attemptNo,
          isMaxAttempts: isMaxAttempts,
        ));
      },
    );
  }

  void _onNextQuestion(
    ActivityNextQuestion event,
    Emitter<ActivityPlayerState> emit,
  ) {
    final currentState = state;
    if (currentState is! ActivityPlayerAnswerFeedback) return;

    final nextIndex = currentState.questionIndex + 1;

    if (nextIndex >= currentState.activity.questions.length) {
      // All questions done → trigger completion
      add(const ActivitySessionCompleteRequested());
      return;
    }

    emit(ActivityPlayerQuestionActive(
      activity: currentState.activity,
      sessionId: currentState.sessionId,
      questionIndex: nextIndex,
      sessionStartMs: currentState.sessionStartMs,
      questionStartMs: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  Future<void> _onCompleteRequested(
    ActivitySessionCompleteRequested event,
    Emitter<ActivityPlayerState> emit,
  ) async {
    final currentState = state;
    String sessionId;
    int sessionStartMs;

    if (currentState is ActivityPlayerAnswerFeedback) {
      sessionId = currentState.sessionId;
      sessionStartMs = currentState.sessionStartMs;
    } else {
      return;
    }

    emit(const ActivityPlayerCompleting());

    final durationMs =
        DateTime.now().millisecondsSinceEpoch - sessionStartMs;

    final result = await completeSession(
      sessionId,
      durationMs: durationMs,
    );

    result.fold(
      (failure) => emit(ActivityPlayerError(failure)),
      (sessionResult) => emit(ActivityPlayerResult(
        result: sessionResult,
        childId: _childId ?? '',
      )),
    );
  }

  void _onRetryRequested(
    ActivityRetryRequested event,
    Emitter<ActivityPlayerState> emit,
  ) {
    if (_childId != null) {
      add(ActivityStartRequested(
        childId: _childId!,
        skillId: _skillId,
        difficulty: _difficulty,
      ));
    }
  }

  void _onExitRequested(
    ActivityExitRequested event,
    Emitter<ActivityPlayerState> emit,
  ) {
    emit(const ActivityPlayerIdle());
  }

  // ── Retry incorrect answer ─────────────────────────────────────────────────
  // Public method called from the UI; dispatches an internal event.

  void retryCurrentQuestion() {
    add(const ActivityRetryCurrentQuestion());
  }

  void _onRetryCurrentQuestion(
    ActivityRetryCurrentQuestion event,
    Emitter<ActivityPlayerState> emit,
  ) {
    final currentState = state;
    if (currentState is! ActivityPlayerAnswerFeedback) return;
    if (currentState.isCorrect || currentState.isMaxAttempts) return;

    emit(ActivityPlayerQuestionActive(
      activity: currentState.activity,
      sessionId: currentState.sessionId,
      questionIndex: currentState.questionIndex,
      sessionStartMs: currentState.sessionStartMs,
      questionStartMs: DateTime.now().millisecondsSinceEpoch,
      attemptNo: currentState.attemptNo,
    ));
  }
}
