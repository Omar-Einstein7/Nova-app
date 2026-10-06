import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/child.dart';

abstract class ChildrenRepository {
  Future<Either<Failure, List<Child>>> listChildren();

  Future<Either<Failure, Child>> getChild(String id);

  Future<Either<Failure, Child>> createChild({
    required String name,
    required DateTime birthDate,
    required List<String> interests,
    required LearningStyle learningStyle,
    required List<String> skillIds,
    String? avatar,
  });

  Future<Either<Failure, Child>> updateChild({
    required String id,
    required String name,
    required DateTime birthDate,
    required List<String> interests,
    required LearningStyle learningStyle,
    required List<String> skillIds,
    String? avatar,
  });

  Future<Either<Failure, Unit>> deleteChild(String id);
}
