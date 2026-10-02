import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Abstract contract for authentication operations.
abstract interface class AuthRepository {
  /// Register a new parent account.
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Login with existing credentials.
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Logout and invalidate the refresh token on the server.
  /// Local tokens are always cleared, even on network failure.
  Future<Either<Failure, Unit>> logout();

  /// Fetch the current user profile.
  Future<Either<Failure, User>> getMe();

  /// Update the display name.
  Future<Either<Failure, User>> updateName(String name);

  /// Permanently delete the account.
  Future<Either<Failure, Unit>> deleteAccount(String password);

  /// Restore session from stored tokens.
  /// Returns [User] if tokens exist and /me succeeds, otherwise [Failure].
  Future<Either<Failure, User>> restoreSession();
}
