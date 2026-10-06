import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/child.dart';
import '../../domain/repositories/children_repository.dart';
import '../datasources/children_remote_data_source.dart';
import '../models/child_model.dart';

class ChildrenRepositoryImpl implements ChildrenRepository {
  const ChildrenRepositoryImpl({required this.remoteDataSource});
  final ChildrenRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<Child>>> listChildren() async {
    final result = await remoteDataSource.listChildren();
    return result.map((models) => models.map((m) => m.toDomain()).toList());
  }

  @override
  Future<Either<Failure, Child>> getChild(String id) async {
    final result = await remoteDataSource.getChild(id);
    return result.map((m) => m.toDomain());
  }

  @override
  Future<Either<Failure, Child>> createChild({
    required String name,
    required DateTime birthDate,
    required List<String> interests,
    required LearningStyle learningStyle,
    required List<String> skillIds,
    String? avatar,
  }) async {
    final body = buildChildBody(
      name: name,
      birthDate: birthDate,
      interests: interests,
      learningStyle: learningStyle,
      skillIds: skillIds,
      avatar: avatar,
    );
    final result = await remoteDataSource.createChild(body);
    return result.map((m) => m.toDomain());
  }

  @override
  Future<Either<Failure, Child>> updateChild({
    required String id,
    required String name,
    required DateTime birthDate,
    required List<String> interests,
    required LearningStyle learningStyle,
    required List<String> skillIds,
    String? avatar,
  }) async {
    final body = buildChildBody(
      name: name,
      birthDate: birthDate,
      interests: interests,
      learningStyle: learningStyle,
      skillIds: skillIds,
      avatar: avatar,
    );
    final result = await remoteDataSource.updateChild(id, body);
    return result.map((m) => m.toDomain());
  }

  @override
  Future<Either<Failure, Unit>> deleteChild(String id) =>
      remoteDataSource.deleteChild(id);
}
