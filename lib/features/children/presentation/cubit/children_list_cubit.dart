import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/child.dart';
import '../../domain/usecases/children_use_cases.dart';
import 'children_list_state.dart';

class ChildrenListCubit extends Cubit<ChildrenListState> {
  ChildrenListCubit({
    required GetChildrenUseCase getChildren,
    required DeleteChildUseCase deleteChild,
  })  : _getChildren = getChildren,
        _deleteChild = deleteChild,
        super(const ChildrenListState.initial());

  final GetChildrenUseCase _getChildren;
  final DeleteChildUseCase _deleteChild;

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> load() async {
    emit(const ChildrenListState.loading());
    final result = await _getChildren();
    result.fold(
      (f) => emit(ChildrenListState.error(f)),
      (children) => emit(ChildrenListState.loaded(children)),
    );
  }

  // ── Optimistic insert after create ────────────────────────────────────────

  void childCreated(Child child) {
    final current = _currentChildren;
    emit(ChildrenListState.loaded([...current, child]));
  }

  // ── Optimistic replace after edit ─────────────────────────────────────────

  void childUpdated(Child child) {
    final current = _currentChildren;
    emit(ChildrenListState.loaded(
      current.map((c) => c.id == child.id ? child : c).toList(),
    ));
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> deleteChild(String id) async {
    final result = await _deleteChild(id);
    result.fold(
      (_) => load(), // refresh on failure to restore state
      (_) {
        final current = _currentChildren;
        emit(ChildrenListState.loaded(
          current.where((c) => c.id != id).toList(),
        ));
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<Child> get _currentChildren => switch (state) {
        ChildrenListStateLoaded(:final children) => children,
        _ => [],
      };
}
