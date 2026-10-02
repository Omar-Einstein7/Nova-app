import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// Permanently deletes the current user's account.
/// Requires the password for server-side confirmation.
class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call(String password) =>
      _repository.deleteAccount(password);
}
