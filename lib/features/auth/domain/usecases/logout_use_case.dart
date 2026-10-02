import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Logs out the current user.
/// Always clears local tokens even if the server call fails.
class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.logout();
}
