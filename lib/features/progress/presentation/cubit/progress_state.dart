import 'package:equatable/equatable.dart';

import '../../domain/entities/progress_entities.dart';

sealed class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

class ProgressLoaded extends ProgressState {
  const ProgressLoaded({required this.overview});
  final ProgressOverview overview;

  @override
  List<Object?> get props => [overview];
}

class ProgressEmpty extends ProgressState {
  const ProgressEmpty();
}

class ProgressError extends ProgressState {
  const ProgressError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
