import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nova/core/error/failures.dart';
import 'package:nova/features/children/domain/entities/child.dart';
import 'package:nova/features/children/domain/usecases/children_use_cases.dart';
import 'package:nova/features/children/presentation/cubit/children_list_cubit.dart';
import 'package:nova/features/children/presentation/cubit/children_list_state.dart';

class _MockGetChildrenUseCase extends Mock implements GetChildrenUseCase {}

class _MockDeleteChildUseCase extends Mock implements DeleteChildUseCase {}

const _tChild1 = Child(
  id: 'c1',
  name: 'عمر',
  age: 6,
  interests: ['حيوانات'],
  learningStyle: LearningStyle.visual,
  skills: [],
);

const _tChild2 = Child(
  id: 'c2',
  name: 'سارة',
  age: 8,
  interests: ['موسيقى'],
  learningStyle: LearningStyle.auditory,
  skills: [],
);

void main() {
  late _MockGetChildrenUseCase mockGetChildren;
  late _MockDeleteChildUseCase mockDeleteChild;

  setUp(() {
    mockGetChildren = _MockGetChildrenUseCase();
    mockDeleteChild = _MockDeleteChildUseCase();
  });

  ChildrenListCubit buildCubit() => ChildrenListCubit(
        getChildren: mockGetChildren,
        deleteChild: mockDeleteChild,
      );

  group('ChildrenListCubit', () {
    test('initial state is ChildrenListStateInitial', () {
      expect(buildCubit().state, const ChildrenListState.initial());
    });

    blocTest<ChildrenListCubit, ChildrenListState>(
      'load emits [loading, loaded] on success',
      setUp: () {
        when(() => mockGetChildren())
            .thenAnswer((_) async => const Right([_tChild1, _tChild2]));
      },
      build: buildCubit,
      act: (c) => c.load(),
      expect: () => [
        const ChildrenListState.loading(),
        const ChildrenListState.loaded([_tChild1, _tChild2]),
      ],
    );

    blocTest<ChildrenListCubit, ChildrenListState>(
      'load emits [loading, error] on failure',
      setUp: () {
        when(() => mockGetChildren())
            .thenAnswer((_) async => const Left(Failure.network()));
      },
      build: buildCubit,
      act: (c) => c.load(),
      expect: () => [
        const ChildrenListState.loading(),
        const ChildrenListState.error(Failure.network()),
      ],
    );

    blocTest<ChildrenListCubit, ChildrenListState>(
      'childCreated appends new child to current list',
      build: buildCubit,
      seed: () => const ChildrenListState.loaded([_tChild1]),
      act: (c) => c.childCreated(_tChild2),
      expect: () => [
        const ChildrenListState.loaded([_tChild1, _tChild2]),
      ],
    );

    blocTest<ChildrenListCubit, ChildrenListState>(
      'childUpdated replaces edited child in list',
      build: buildCubit,
      seed: () => const ChildrenListState.loaded([_tChild1]),
      act: (c) => c.childUpdated(
        const Child(
          id: 'c1',
          name: 'عمر المحدث',
          age: 7,
          interests: ['فضاء'],
          learningStyle: LearningStyle.mixed,
          skills: [],
        ),
      ),
      expect: () => [
        const ChildrenListState.loaded([
          Child(
            id: 'c1',
            name: 'عمر المحدث',
            age: 7,
            interests: ['فضاء'],
            learningStyle: LearningStyle.mixed,
            skills: [],
          ),
        ]),
      ],
    );

    blocTest<ChildrenListCubit, ChildrenListState>(
      'deleteChild removes child from list on success',
      setUp: () {
        when(() => mockDeleteChild('c1'))
            .thenAnswer((_) async => const Right(unit));
      },
      build: buildCubit,
      seed: () => const ChildrenListState.loaded([_tChild1, _tChild2]),
      act: (c) => c.deleteChild('c1'),
      expect: () => [
        const ChildrenListState.loaded([_tChild2]),
      ],
      verify: (_) => verify(() => mockDeleteChild('c1')).called(1),
    );
  });
}
