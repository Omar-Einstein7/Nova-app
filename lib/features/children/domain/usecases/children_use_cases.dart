import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/child.dart';
import '../repositories/children_repository.dart';

class GetChildrenUseCase {
  const GetChildrenUseCase(this._repo);
  final ChildrenRepository _repo;
  Future<Either<Failure, List<Child>>> call() => _repo.listChildren();
}

class GetChildUseCase {
  const GetChildUseCase(this._repo);
  final ChildrenRepository _repo;
  Future<Either<Failure, Child>> call(String id) => _repo.getChild(id);
}

class CreateChildUseCase {
  const CreateChildUseCase(this._repo);
  final ChildrenRepository _repo;

  Future<Either<Failure, Child>> call({
    required String name,
    required DateTime birthDate,
    required List<String> interests,
    required LearningStyle learningStyle,
    required List<String> skillIds,
    String? avatar,
  }) =>
      _repo.createChild(
        name: name,
        birthDate: birthDate,
        interests: interests,
        learningStyle: learningStyle,
        skillIds: skillIds,
        avatar: avatar,
      );
}

class UpdateChildUseCase {
  const UpdateChildUseCase(this._repo);
  final ChildrenRepository _repo;

  Future<Either<Failure, Child>> call({
    required String id,
    required String name,
    required DateTime birthDate,
    required List<String> interests,
    required LearningStyle learningStyle,
    required List<String> skillIds,
    String? avatar,
  }) =>
      _repo.updateChild(
        id: id,
        name: name,
        birthDate: birthDate,
        interests: interests,
        learningStyle: learningStyle,
        skillIds: skillIds,
        avatar: avatar,
      );
}

class DeleteChildUseCase {
  const DeleteChildUseCase(this._repo);
  final ChildrenRepository _repo;
  Future<Either<Failure, Unit>> call(String id) => _repo.deleteChild(id);
}
