import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/skill.dart';
import '../repositories/skills_repository.dart';

/// Fetches skills from the repository.
/// Session-level caching lives in [SkillsCubit], not here.
class GetSkillsUseCase {
  const GetSkillsUseCase(this._repository);
  final SkillsRepository _repository;

  Future<Either<Failure, List<Skill>>> call() => _repository.getSkills();
}
