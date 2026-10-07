import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/progress_entities.dart';

class ProgressRemoteDataSource {
  const ProgressRemoteDataSource(this._dio);
  final Dio _dio;

  // ── Overview ───────────────────────────────────────────────────────────────

  Future<Either<Failure, ProgressOverview>> getOverview(
    String childId, {
    required String range,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/children/$childId/progress',
        queryParameters: {'range': range},
      );
      final data = res.data!['data'] as Map<String, dynamic>;
      return Right(_parseOverview(data));
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Skill chart ────────────────────────────────────────────────────────────

  Future<Either<Failure, List<SkillChartPoint>>> getSkillChart(
    String childId,
    String skillId, {
    String range = '7d',
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/children/$childId/progress/skills/$skillId',
        queryParameters: {'range': range},
      );
      final data = res.data!['data'] as Map<String, dynamic>;
      final points = (data['points'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_parseChartPoint)
          .toList();
      return Right(points);
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Sessions ───────────────────────────────────────────────────────────────

  Future<Either<Failure, List<SessionSummary>>> getSessions(
    String childId, {
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final params = <String, dynamic>{'limit': limit};
      if (cursor != null) params['cursor'] = cursor;
      final res = await _dio.get<Map<String, dynamic>>(
        '/children/$childId/sessions',
        queryParameters: params,
      );
      final data = res.data!['data'] as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_parseSession)
          .toList();
      return Right(items);
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Parsers ────────────────────────────────────────────────────────────────

  static ProgressOverview _parseOverview(Map<String, dynamic> d) {
    final bySkill = (d['bySkill'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map((s) => SkillProgress(
              skillId: s['skillId'] as String,
              key: s['key'] as String,
              nameAr: s['nameAr'] as String? ?? s['key'] as String,
              avgSuccessRate: (s['avgSuccessRate'] as num?)?.toDouble() ?? 0.0,
              sessions: (s['sessions'] as num?)?.toInt() ?? 0,
              level: s['level'] as String? ?? 'BEGINNER',
            ))
        .toList();

    return ProgressOverview(
      range: d['range'] as String? ?? '7d',
      sessionsCount: (d['sessionsCount'] as num?)?.toInt() ?? 0,
      avgSuccessRate: (d['avgSuccessRate'] as num?)?.toDouble() ?? 0.0,
      totalMinutes: (d['totalMinutes'] as num?)?.toInt() ?? 0,
      streakDays: (d['streakDays'] as num?)?.toInt() ?? 0,
      bySkill: bySkill,
    );
  }

  static SkillChartPoint _parseChartPoint(Map<String, dynamic> d) =>
      SkillChartPoint(
        date: DateTime.parse(d['date'] as String),
        avgSuccessRate: (d['avgSuccessRate'] as num).toDouble(),
      );

  static SessionSummary _parseSession(Map<String, dynamic> d) => SessionSummary(
        id: d['id'] as String,
        activityTitle: d['activityTitle'] as String? ?? '',
        skillKey: d['skillKey'] as String? ?? '',
        startedAt: DateTime.parse(d['startedAt'] as String),
        durationMs: (d['durationMs'] as num?)?.toInt() ?? 0,
        successRate: (d['successRate'] as num?)?.toDouble() ?? 0.0,
        stars: (d['stars'] as num?)?.toInt() ?? 0,
        status: d['status'] as String? ?? 'COMPLETED',
      );
}
