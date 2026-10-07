import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/progress_entities.dart';
import '../repositories/progress_repository.dart';

class GetProgressOverviewUseCase {
  const GetProgressOverviewUseCase(this._repo);
  final ProgressRepository _repo;

  Future<Either<Failure, ProgressOverview>> call(
    String childId, {
    required String range,
  }) =>
      _repo.getOverview(childId, range: range);
}

class GetSkillChartUseCase {
  const GetSkillChartUseCase(this._repo);
  final ProgressRepository _repo;

  Future<Either<Failure, List<SkillChartPoint>>> call(
    String childId,
    String skillId, {
    String range = '7d',
  }) =>
      _repo.getSkillChart(childId, skillId, range: range);
}

class GetSessionsUseCase {
  const GetSessionsUseCase(this._repo);
  final ProgressRepository _repo;

  Future<Either<Failure, List<SessionSummary>>> call(
    String childId, {
    int limit = 20,
    String? cursor,
  }) =>
      _repo.getSessions(childId, limit: limit, cursor: cursor);
}
