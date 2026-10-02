import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Registers a new parent account and returns the created [User].
class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String password,
  }) =>
      _repository.register(name: name, email: email, password: password);
}
