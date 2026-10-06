import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class GenerateActivityUseCase {
  const GenerateActivityUseCase(this._repository);
  final ActivityRepository _repository;

  Future<Either<Failure, Activity>> call(
    String childId, {
    String? skillId,
    String? difficulty,
  }) =>
      _repository.generate(childId, skillId: skillId, difficulty: difficulty);
}

class StartSessionUseCase {
  const StartSessionUseCase(this._repository);
  final ActivityRepository _repository;

  Future<Either<Failure, ActivitySession>> call(String activityId) =>
      _repository.startSession(activityId);
}

class SubmitAnswerUseCase {
  const SubmitAnswerUseCase(this._repository);
  final ActivityRepository _repository;

  Future<Either<Failure, AnswerResult>> call(
    String sessionId, {
    required int questionIndex,
    required String selectedAnswer,
    required int timeMs,
    required bool usedHelp,
  }) =>
      _repository.submitAnswer(
        sessionId,
        questionIndex: questionIndex,
        selectedAnswer: selectedAnswer,
        timeMs: timeMs,
        usedHelp: usedHelp,
      );
}

class CompleteSessionUseCase {
  const CompleteSessionUseCase(this._repository);
  final ActivityRepository _repository;

  Future<Either<Failure, SessionResult>> call(
    String sessionId, {
    required int durationMs,
  }) =>
      _repository.completeSession(sessionId, durationMs: durationMs);
}
