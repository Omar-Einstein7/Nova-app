import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/skill.dart';

abstract class SkillsRepository {
  /// Returns all skills. Callers should go through [GetSkillsUseCase]
  /// which caches the result for the session.
  Future<Either<Failure, List<Skill>>> getSkills();
}
