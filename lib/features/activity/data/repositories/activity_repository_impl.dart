import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_remote_data_source.dart';
import '../datasources/fake_activity_data_source.dart';

/// Toggle with --dart-define=USE_MOCK=true
const bool _useMock = bool.fromEnvironment('USE_MOCK', defaultValue: false);

class ActivityRepositoryImpl implements ActivityRepository {
  const ActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.fakeDataSource,
  });

  final ActivityRemoteDataSource remoteDataSource;
  final FakeActivityDataSource fakeDataSource;

  @override
  Future<Either<Failure, Activity>> generate(
    String childId, {
    String? skillId,
    String? difficulty,
  }) =>
      _useMock
          ? fakeDataSource.generate(childId,
              skillId: skillId, difficulty: difficulty)
          : remoteDataSource.generate(childId,
              skillId: skillId, difficulty: difficulty);

  @override
  Future<Either<Failure, ActivitySession>> startSession(
          String activityId) =>
      _useMock
          ? fakeDataSource.startSession(activityId)
          : remoteDataSource.startSession(activityId);

  @override
  Future<Either<Failure, AnswerResult>> submitAnswer(
    String sessionId, {
    required int questionIndex,
    required String selectedAnswer,
    required int timeMs,
    required bool usedHelp,
  }) =>
      _useMock
          ? fakeDataSource.submitAnswer(
              sessionId,
              questionIndex: questionIndex,
              selectedAnswer: selectedAnswer,
              timeMs: timeMs,
              usedHelp: usedHelp,
            )
          : remoteDataSource.submitAnswer(
              sessionId,
              questionIndex: questionIndex,
              selectedAnswer: selectedAnswer,
              timeMs: timeMs,
              usedHelp: usedHelp,
            );

  @override
  Future<Either<Failure, SessionResult>> completeSession(
    String sessionId, {
    required int durationMs,
  }) =>
      _useMock
          ? fakeDataSource.completeSession(sessionId, durationMs: durationMs)
          : remoteDataSource.completeSession(sessionId, durationMs: durationMs);
}
