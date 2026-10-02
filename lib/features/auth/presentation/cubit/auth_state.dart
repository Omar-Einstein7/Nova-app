import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// The three possible authentication states for the NOVA app.
@freezed
sealed class AuthState with _$AuthState {
  /// Startup: we don't yet know whether the user is logged in.
  const factory AuthState.unknown() = AuthStateUnknown;

  /// A valid session exists and the user profile is loaded.
  const factory AuthState.authenticated(User user) = AuthStateAuthenticated;

  /// No valid session (never logged in, logged out, or session expired).
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
}
