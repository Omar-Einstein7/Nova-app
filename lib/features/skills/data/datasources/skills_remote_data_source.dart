import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../models/skill_model.dart';

class SkillsRemoteDataSource {
  const SkillsRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Either<Failure, List<SkillModel>>> getSkills() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/skills');
      final data = response.data!['data'] as List<dynamic>;
      final skills = data
          .cast<Map<String, dynamic>>()
          .map(SkillModel.fromJson)
          .toList();
      return Right(skills);
    } on DioException catch (e) {
      return Left(ErrorMapper.fromDioException(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
