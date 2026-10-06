import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nova/core/error/failures.dart';
import 'package:nova/features/skills/domain/entities/skill.dart';
import 'package:nova/features/skills/domain/usecases/get_skills_use_case.dart';
import 'package:nova/features/skills/presentation/cubit/skills_cubit.dart';
import 'package:nova/features/skills/presentation/cubit/skills_state.dart';

class _MockGetSkillsUseCase extends Mock implements GetSkillsUseCase {}

const _tSkills = [
  Skill(
    id: 's1',
    key: 'colors',
    nameAr: 'الألوان',
    nameEn: 'Colors',
    description: 'التعرف على الألوان الأساسية',
  ),
  Skill(
    id: 's2',
    key: 'shapes',
    nameAr: 'الأشكال',
    nameEn: 'Shapes',
    description: 'تمييز الأشكال الهندسية',
  ),
];

void main() {
  late _MockGetSkillsUseCase mockGetSkills;

  setUp(() {
    mockGetSkills = _MockGetSkillsUseCase();
  });

  SkillsCubit buildCubit() => SkillsCubit(getSkillsUseCase: mockGetSkills);

  group('SkillsCubit', () {
    test('initial state is SkillsStateInitial', () {
      expect(buildCubit().state, const SkillsState.initial());
    });

    blocTest<SkillsCubit, SkillsState>(
      'emits [loading, loaded] when getSkills succeeds',
      setUp: () {
        when(() => mockGetSkills()).thenAnswer((_) async => const Right(_tSkills));
      },
      build: buildCubit,
      act: (c) => c.load(),
      expect: () => [
        const SkillsState.loading(),
        const SkillsState.loaded(_tSkills),
      ],
      verify: (_) => verify(() => mockGetSkills()).called(1),
    );

    blocTest<SkillsCubit, SkillsState>(
      'does NOT refetch if already loaded and forceRefresh is false',
      setUp: () {
        when(() => mockGetSkills()).thenAnswer((_) async => const Right(_tSkills));
      },
      build: buildCubit,
      seed: () => const SkillsState.loaded(_tSkills),
      act: (c) => c.load(forceRefresh: false),
      expect: () => [],
      verify: (_) => verifyNever(() => mockGetSkills()),
    );

    blocTest<SkillsCubit, SkillsState>(
      'refetches if forceRefresh is true',
      setUp: () {
        when(() => mockGetSkills()).thenAnswer((_) async => const Right(_tSkills));
      },
      build: buildCubit,
      seed: () => const SkillsState.loaded(_tSkills),
      act: (c) => c.load(forceRefresh: true),
      expect: () => [
        const SkillsState.loading(),
        const SkillsState.loaded(_tSkills),
      ],
      verify: (_) => verify(() => mockGetSkills()).called(1),
    );

    blocTest<SkillsCubit, SkillsState>(
      'emits [loading, error] on failure',
      setUp: () {
        when(() => mockGetSkills()).thenAnswer(
          (_) async => const Left(Failure.network(message: 'error')),
        );
      },
      build: buildCubit,
      act: (c) => c.load(),
      expect: () => [
        const SkillsState.loading(),
        const SkillsState.error(Failure.network(message: 'error')),
      ],
    );
  });
}
