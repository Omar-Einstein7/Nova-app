import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nova/core/error/failures.dart';

import '../../domain/entities/progress_entities.dart';
import '../../domain/usecases/progress_use_cases.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class SessionsHistoryState extends Equatable {
  const SessionsHistoryState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage = '',
    this.hasMore = true,
    this.cursor,
  });

  final List<SessionSummary> items;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String errorMessage;
  final bool hasMore;
  final String? cursor;

  SessionsHistoryState copyWith({
    List<SessionSummary>? items,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    String? errorMessage,
    bool? hasMore,
    String? cursor,
  }) =>
      SessionsHistoryState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasError: hasError ?? this.hasError,
        errorMessage: errorMessage ?? this.errorMessage,
        hasMore: hasMore ?? this.hasMore,
        cursor: cursor ?? this.cursor,
      );

  @override
  List<Object?> get props => [
        items,
        isLoading,
        isLoadingMore,
        hasError,
        errorMessage,
        hasMore,
        cursor,
      ];
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Infinite-scroll cubit for the session history list.
class SessionsHistoryCubit extends Cubit<SessionsHistoryState> {
  SessionsHistoryCubit({
    required this.childId,
    required GetSessionsUseCase getSessions,
  })  : _getSessions = getSessions,
        super(const SessionsHistoryState(isLoading: true));

  final String childId;
  final GetSessionsUseCase _getSessions;

  static const _pageSize = 20;

  Future<void> load() async {
    emit(const SessionsHistoryState(isLoading: true));
    final result = await _getSessions(childId, limit: _pageSize);
    result.fold(
      (f) => emit(SessionsHistoryState(
        hasError: true,
        errorMessage: f.map(
          network: (_) => 'تعذّر الاتصال بالإنترنت.',
          timeout: (_) => 'انتهت مهلة الاتصال.',
          server: (s) => s.message,
          unauthorized: (_) => 'انتهت الجلسة.',
          validation: (_) => 'بيانات غير صحيحة.',
          unknown: (u) => u.message ?? 'خطأ غير متوقع.',
        ),
      )),
      (items) => emit(SessionsHistoryState(
        items: items,
        hasMore: items.length == _pageSize,
        // No cursor support from the fake source; for real API pass nextCursor
        cursor: null,
      )),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    final result =
        await _getSessions(childId, limit: _pageSize, cursor: state.cursor);
    result.fold(
      (_) => emit(state.copyWith(isLoadingMore: false)),
      (newItems) => emit(state.copyWith(
        items: [...state.items, ...newItems],
        isLoadingMore: false,
        hasMore: newItems.length == _pageSize,
        cursor: null,
      )),
    );
  }
}
