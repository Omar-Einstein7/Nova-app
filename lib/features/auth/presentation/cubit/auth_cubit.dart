import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/session_expired_event.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/restore_session_use_case.dart';
import 'auth_state.dart';

/// App-scoped cubit that owns the authentication lifecycle.
///
/// - Starts in [AuthStateUnknown].
/// - [restoreSession] determines the initial state on app start.
/// - Subscribes to [SessionExpiredEvent] (emitted by [AuthInterceptor] on
///   failed refresh) and transitions to [AuthStateUnauthenticated].
/// - Exposes [authStatusListenable] so [GoRouter] can react to state changes.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required RestoreSessionUseCase restoreSessionUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _restoreSession = restoreSessionUseCase,
        _logout = logoutUseCase,
        super(const AuthState.unknown()) {
    // Subscribe to the broadcast stream from the network interceptor.
    _sessionExpiredSub = SessionExpiredEvent.stream.listen((_) {
      if (state is! AuthStateUnauthenticated) {
        emit(const AuthState.unauthenticated());
        _routerNotifier.notifyListeners();
      }
    });
  }

  final RestoreSessionUseCase _restoreSession;
  final LogoutUseCase _logout;
  late final StreamSubscription<void> _sessionExpiredSub;

  /// A [ChangeNotifier] that [GoRouter.refreshListenable] can observe.
  /// Updated every time the auth state changes.
  final _routerNotifier = _AuthRouterNotifier();
  Listenable get routerListenable => _routerNotifier;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call on app startup to determine the initial auth state.
  Future<void> restoreSession() async {
    emit(const AuthState.unknown());
    final result = await _restoreSession();
    result.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
    _routerNotifier.notifyListeners();
  }

  /// Called after a successful login or registration.
  void onLoggedIn(User user) {
    emit(AuthState.authenticated(user));
    _routerNotifier.notifyListeners();
  }

  /// Logs out, always clearing local tokens.
  Future<void> logout() async {
    // Optimistically move to unauthenticated and notify router immediately
    // so the UI transitions before waiting for the network.
    emit(const AuthState.unauthenticated());
    _routerNotifier.notifyListeners();
    await _logout();
  }

  /// Called after successful account deletion.
  void onAccountDeleted() {
    emit(const AuthState.unauthenticated());
    _routerNotifier.notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Whether the cubit is currently in an authenticated state.
  bool get isAuthenticated => state is AuthStateAuthenticated;

  /// The currently authenticated user, or null.
  User? get currentUser =>
      state is AuthStateAuthenticated ? (state as AuthStateAuthenticated).user : null;

  @override
  Future<void> close() {
    _sessionExpiredSub.cancel();
    _routerNotifier.dispose();
    return super.close();
  }
}

// ── Router notifier ──────────────────────────────────────────────────────────

/// Thin [ChangeNotifier] owned by [AuthCubit] for [GoRouter.refreshListenable].
class _AuthRouterNotifier extends ChangeNotifier {
  @override
  // ignore: unnecessary_overrides
  void notifyListeners() => super.notifyListeners();
}
