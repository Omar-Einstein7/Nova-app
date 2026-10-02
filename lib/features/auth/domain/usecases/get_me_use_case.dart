import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Fetches the authenticated user's profile.
class GetMeUseCase {
  const GetMeUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, User>> call() => _repository.getMe();
}
