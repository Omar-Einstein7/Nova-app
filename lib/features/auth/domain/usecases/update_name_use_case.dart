import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Updates the parent's display name.
class UpdateNameUseCase {
  const UpdateNameUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, User>> call(String name) =>
      _repository.updateName(name);
}
