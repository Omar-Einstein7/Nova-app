import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nova/core/error/failures.dart';
import 'package:nova/features/children/data/datasources/children_remote_data_source.dart';
import 'package:nova/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:nova/features/home/presentation/cubit/dashboard_state.dart';

class _MockChildrenRemoteDataSource extends Mock
    implements ChildrenRemoteDataSource {}

const _tRecommendation = {
  'skillId': 's1',
  'skillName': 'الألوان',
  'difficulty': 'BEGINNER',
  'reason': 'موصى به للبدء',
  'suggestBreak': false,
};

const _tProgress = {
  'sessionsCount': 5,
  'streakDays': 3,
  'avgSuccessRate': 0.85,
};

void main() {
  late _MockChildrenRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = _MockChildrenRemoteDataSource();
  });

  DashboardCubit buildCubit() => DashboardCubit(
        dataSource: mockDataSource,
        childId: 'c1',
      );

  group('DashboardCubit', () {
    test('initial state is DashboardStateLoading', () {
      expect(buildCubit().state, const DashboardState.loading());
    });

    blocTest<DashboardCubit, DashboardState>(
      'load emits loaded state when recommendation and progress succeed',
      setUp: () {
        when(() => mockDataSource.getNextRecommendation('c1'))
            .thenAnswer((_) async => const Right(_tRecommendation));
        when(() => mockDataSource.getProgress('c1', range: '7d'))
            .thenAnswer((_) async => const Right(_tProgress));
      },
      build: buildCubit,
      act: (c) => c.load(),
      expect: () => [
        const DashboardState.loading(),
        const DashboardState.loaded(
          recommendation: _tRecommendation,
          progress: _tProgress,
        ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'load gracefully accepts null progress if progress call fails',
      setUp: () {
        when(() => mockDataSource.getNextRecommendation('c1'))
            .thenAnswer((_) async => const Right(_tRecommendation));
        when(() => mockDataSource.getProgress('c1', range: '7d'))
            .thenAnswer((_) async => const Left(Failure.server(code: 'INTERNAL', message: 'error')));
      },
      build: buildCubit,
      act: (c) => c.load(),
      expect: () => [
        const DashboardState.loading(),
        const DashboardState.loaded(
          recommendation: _tRecommendation,
          progress: null,
        ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'load emits error state when recommendation call fails',
      setUp: () {
        when(() => mockDataSource.getNextRecommendation('c1'))
            .thenAnswer((_) async => const Left(Failure.network()));
        when(() => mockDataSource.getProgress('c1', range: '7d'))
            .thenAnswer((_) async => const Right(_tProgress));
      },
      build: buildCubit,
      act: (c) => c.load(),
      expect: () => [
        const DashboardState.loading(),
        const DashboardState.error(Failure.network()),
      ],
    );
  });
}
