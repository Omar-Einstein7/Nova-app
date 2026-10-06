import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/child.dart';
import '../models/child_model.dart';

class ChildrenRemoteDataSource {
  const ChildrenRemoteDataSource(this._dio);
  final Dio _dio;

  // ── List ───────────────────────────────────────────────────────────────────

  Future<Either<Failure, List<ChildModel>>> listChildren() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/children');
      final data = res.data!['data'] as List<dynamic>;
      return Right(
        data.cast<Map<String, dynamic>>().map(ChildModel.fromJson).toList(),
      );
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Get one ────────────────────────────────────────────────────────────────

  Future<Either<Failure, ChildModel>> getChild(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/children/$id');
      return Right(ChildModel.fromJson(res.data!['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────

  Future<Either<Failure, ChildModel>> createChild(
      Map<String, dynamic> body) async {
    try {
      final res =
          await _dio.post<Map<String, dynamic>>('/children', data: body);
      return Right(ChildModel.fromJson(res.data!['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────────

  Future<Either<Failure, ChildModel>> updateChild(
      String id, Map<String, dynamic> body) async {
    try {
      final res =
          await _dio.patch<Map<String, dynamic>>('/children/$id', data: body);
      return Right(ChildModel.fromJson(res.data!['data'] as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<Either<Failure, Unit>> deleteChild(String id) async {
    try {
      await _dio.delete<void>('/children/$id');
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Recommendation ─────────────────────────────────────────────────────────

  Future<Either<Failure, Map<String, dynamic>>> getNextRecommendation(
      String childId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
          '/children/$childId/recommendations/next');
      return Right(res.data!['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Progress ───────────────────────────────────────────────────────────────

  Future<Either<Failure, Map<String, dynamic>>> getProgress(
    String childId, {
    String range = '7d',
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/children/$childId/progress',
        queryParameters: {'range': range},
      );
      return Right(res.data!['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}

// ── Request body helpers ──────────────────────────────────────────────────────

String _learningStyleToApiString(LearningStyle s) => switch (s) {
      LearningStyle.visual => 'VISUAL',
      LearningStyle.auditory => 'AUDITORY',
      LearningStyle.mixed => 'MIXED',
    };

Map<String, dynamic> buildChildBody({
  required String name,
  required DateTime birthDate,
  required List<String> interests,
  required LearningStyle learningStyle,
  required List<String> skillIds,
  String? avatar,
}) =>
    {
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'interests': interests,
      'learningStyle': _learningStyleToApiString(learningStyle),
      'skillIds': skillIds,
      if (avatar != null) 'avatar': avatar,
    };
