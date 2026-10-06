import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/activity.dart';

/// Domain contract for the activity feature.
abstract class ActivityRepository {
  /// POST /children/:childId/activities/generate
  Future<Either<Failure, Activity>> generate(
    String childId, {
    String? skillId,
    String? difficulty,
  });

  /// POST /activities/:activityId/sessions
  Future<Either<Failure, ActivitySession>> startSession(String activityId);

  /// POST /sessions/:sessionId/answers
  Future<Either<Failure, AnswerResult>> submitAnswer(
    String sessionId, {
    required int questionIndex,
    required String selectedAnswer,
    required int timeMs,
    required bool usedHelp,
  });

  /// POST /sessions/:sessionId/complete
  Future<Either<Failure, SessionResult>> completeSession(
    String sessionId, {
    required int durationMs,
  });
}
