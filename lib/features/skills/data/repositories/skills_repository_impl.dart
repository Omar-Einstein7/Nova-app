import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/skill.dart';
import '../../domain/repositories/skills_repository.dart';
import '../datasources/skills_remote_data_source.dart';
import '../models/skill_model.dart';

class SkillsRepositoryImpl implements SkillsRepository {
  const SkillsRepositoryImpl({required this.remoteDataSource});
  final SkillsRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Skill>>> getSkills() async {
    final result = await remoteDataSource.getSkills();
    return result.map((models) => models.map((m) => m.toDomain()).toList());
  }
}
