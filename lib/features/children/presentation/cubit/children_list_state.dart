import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/child.dart';

part 'children_list_state.freezed.dart';

@freezed
sealed class ChildrenListState with _$ChildrenListState {
  const factory ChildrenListState.initial() = ChildrenListStateInitial;
  const factory ChildrenListState.loading() = ChildrenListStateLoading;
  const factory ChildrenListState.loaded(List<Child> children) =
      ChildrenListStateLoaded;
  const factory ChildrenListState.error(Failure failure) =
      ChildrenListStateError;
}
