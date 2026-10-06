import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';

part 'dashboard_state.freezed.dart';

@freezed
sealed class DashboardState with _$DashboardState {
  const factory DashboardState.loading() = DashboardStateLoading;

  const factory DashboardState.loaded({
    required Map<String, dynamic> recommendation,
    Map<String, dynamic>? progress,
  }) = DashboardStateLoaded;

  const factory DashboardState.error(Failure failure) = DashboardStateError;
}
