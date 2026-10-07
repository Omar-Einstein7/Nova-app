import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/progress_entities.dart';

abstract class ProgressRepository {
  Future<Either<Failure, ProgressOverview>> getOverview(
    String childId, {
    required String range,
  });

  Future<Either<Failure, List<SkillChartPoint>>> getSkillChart(
    String childId,
    String skillId, {
    String range = '7d',
  });

  Future<Either<Failure, List<SessionSummary>>> getSessions(
    String childId, {
    int limit = 20,
    String? cursor,
  });
}
