import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Restores the session from locally stored tokens.
/// Returns [User] if valid tokens exist and /me succeeds.
/// Returns [Failure] (without network call) if no tokens are stored.
class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, User>> call() => _repository.restoreSession();
}
