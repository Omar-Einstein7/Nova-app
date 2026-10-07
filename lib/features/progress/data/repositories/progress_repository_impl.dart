import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/progress_entities.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  const ProgressRepositoryImpl({required this.remoteDataSource});

  final ProgressRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, ProgressOverview>> getOverview(
    String childId, {
    required String range,
  }) =>
      remoteDataSource.getOverview(childId, range: range);

  @override
  Future<Either<Failure, List<SkillChartPoint>>> getSkillChart(
    String childId,
    String skillId, {
    String range = '7d',
  }) =>
      remoteDataSource.getSkillChart(childId, skillId, range: range);

  @override
  Future<Either<Failure, List<SessionSummary>>> getSessions(
    String childId, {
    int limit = 20,
    String? cursor,
  }) =>
      remoteDataSource.getSessions(childId, limit: limit, cursor: cursor);
}
