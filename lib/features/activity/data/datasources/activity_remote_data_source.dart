import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../models/activity_models.dart';

/// Remote data source for the activity feature.
/// Uses a longer receive timeout (60s) for the generate endpoint because
/// AI generation can take more time.
class ActivityRemoteDataSource {
  const ActivityRemoteDataSource(this._dio);
  final Dio _dio;

  // ── Generate ───────────────────────────────────────────────────────────────

  Future<Either<Failure, ActivityModel>> generate(
    String childId, {
    String? skillId,
    String? difficulty,
  }) async {
    try {
      final body = <String, dynamic>{
        if (skillId != null) 'skillId': skillId,
        if (difficulty != null) 'difficulty': difficulty,
      };
      final res = await _dio.post<Map<String, dynamic>>(
        '/children/$childId/activities/generate',
        data: body,
        options: Options(receiveTimeout: const Duration(seconds: 60)),
      );
      return Right(
        ActivityModel.fromJson(res.data!['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Start session ──────────────────────────────────────────────────────────

  Future<Either<Failure, ActivitySessionModel>> startSession(
      String activityId) async {
    try {
      final res = await _dio
          .post<Map<String, dynamic>>('/activities/$activityId/sessions');
      return Right(
        ActivitySessionModel.fromJson(
            res.data!['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Submit answer ──────────────────────────────────────────────────────────

  Future<Either<Failure, AnswerResultModel>> submitAnswer(
    String sessionId, {
    required int questionIndex,
    required String selectedAnswer,
    required int timeMs,
    required bool usedHelp,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/sessions/$sessionId/answers',
        data: {
          'questionIndex': questionIndex,
          'selectedAnswer': selectedAnswer,
          'timeMs': timeMs,
          'usedHelp': usedHelp,
        },
      );
      return Right(
        AnswerResultModel.fromJson(res.data!['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Complete session ───────────────────────────────────────────────────────

  Future<Either<Failure, SessionResultModel>> completeSession(
    String sessionId, {
    required int durationMs,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/sessions/$sessionId/complete',
        data: {'durationMs': durationMs},
      );
      return Right(
        SessionResultModel.fromJson(res.data!['data'] as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
