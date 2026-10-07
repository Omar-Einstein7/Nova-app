import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova/core/error/failures.dart';

import '../../domain/usecases/progress_use_cases.dart';
import 'progress_state.dart';

/// Cubit that fetches the progress overview for a single child + date range.
/// Create a new instance per child or when range changes.
class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit({
    required this.childId,
    required GetProgressOverviewUseCase getOverview,
  })  : _getOverview = getOverview,
        super(const ProgressLoading());

  final String childId;
  final GetProgressOverviewUseCase _getOverview;

  String _range = '7d';
  String get range => _range;

  Future<void> load({String range = '7d'}) async {
    _range = range;
    emit(const ProgressLoading());
    final result = await _getOverview(childId, range: range);
    result.fold(
      (failure) {
        final msg = failure.map(
          network: (_) => 'تعذّر الاتصال بالإنترنت.',
          timeout: (_) => 'انتهت مهلة الاتصال.',
          server: (f) => f.message,
          unauthorized: (_) => 'انتهت الجلسة.',
          validation: (_) => 'بيانات غير صحيحة.',
          unknown: (f) => f.message ?? 'خطأ غير متوقع.',
        );
        emit(ProgressError(msg));
      },
      (overview) {
        if (overview.sessionsCount == 0) {
          emit(const ProgressEmpty());
        } else {
          emit(ProgressLoaded(overview: overview));
        }
      },
    );
  }

  void changeRange(String newRange) => load(range: newRange);
}

/// Factory for creating a per-child ProgressCubit.
class ProgressCubitFactory {
  const ProgressCubitFactory({required this.getOverview});
  final GetProgressOverviewUseCase getOverview;

  ProgressCubit create(String childId) =>
      ProgressCubit(childId: childId, getOverview: getOverview);
}
