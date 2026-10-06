import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../children/data/datasources/children_remote_data_source.dart';
import 'dashboard_state.dart';

/// Cubit for the ChildDashboardPage.
/// Parallel-loads recommendation + 7d progress (progress failure is non-fatal).
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required ChildrenRemoteDataSource dataSource,
    required String childId,
  })  : _dataSource = dataSource,
        _childId = childId,
        super(const DashboardState.loading());

  final ChildrenRemoteDataSource _dataSource;
  final String _childId;

  Future<void> load() async {
    emit(const DashboardState.loading());

    // Run recommendation and progress in parallel
    final recFuture = _dataSource.getNextRecommendation(_childId);
    final progressFuture = _dataSource.getProgress(_childId, range: '7d');

    final Either<Failure, Map<String, dynamic>> recResult = await recFuture;
    final Either<Failure, Map<String, dynamic>> progressResult =
        await progressFuture;

    final progressData = progressResult.fold<Map<String, dynamic>?>(
      (_) => null,
      (data) => data,
    );

    recResult.fold(
      (failure) => emit(DashboardState.error(failure)),
      (rec) => emit(DashboardState.loaded(
        recommendation: rec,
        progress: progressData,
      )),
    );
  }
}

/// Factory registered in GetIt for creating a per-child DashboardCubit.
class DashboardCubitFactory {
  const DashboardCubitFactory({required this.dataSource});

  final ChildrenRemoteDataSource dataSource;

  DashboardCubit create(String childId) => DashboardCubit(
        dataSource: dataSource,
        childId: childId,
      );
}
