import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nova/features/children/domain/entities/child.dart';
import 'package:nova/features/children/domain/usecases/children_use_cases.dart';
import 'package:nova/features/children/presentation/cubit/child_form_cubit.dart';
import 'package:nova/features/children/presentation/cubit/child_form_state.dart';

class _MockCreateChildUseCase extends Mock implements CreateChildUseCase {}

class _MockUpdateChildUseCase extends Mock implements UpdateChildUseCase {}

const _tSavedChild = Child(
  id: 'c1',
  name: 'عمر',
  age: 5,
  interests: ['حيوانات'],
  learningStyle: LearningStyle.visual,
  skills: [],
);

void main() {
  late _MockCreateChildUseCase mockCreate;
  late _MockUpdateChildUseCase mockUpdate;

  setUpAll(() {
    registerFallbackValue(DateTime.now());
    registerFallbackValue(LearningStyle.visual);
  });

  setUp(() {
    mockCreate = _MockCreateChildUseCase();
    mockUpdate = _MockUpdateChildUseCase();
  });

  ChildFormCubit buildCubit({Child? existing}) => ChildFormCubit(
        createChild: mockCreate,
        updateChild: mockUpdate,
        existing: existing,
      );

  group('ChildFormCubit', () {
    test('initial state has step 0 and empty fields in create mode', () {
      final cubit = buildCubit();
      expect(cubit.state.currentStep, 0);
      expect(cubit.isEditMode, false);
      expect(cubit.state.name, '');
    });

    test('step navigation bounds checking', () {
      final cubit = buildCubit();
      cubit.prevStep(); // shouldn't go below 0
      expect(cubit.state.currentStep, 0);

      cubit.nextStep();
      expect(cubit.state.currentStep, 1);

      cubit.nextStep();
      expect(cubit.state.currentStep, 2);

      cubit.nextStep(); // shouldn't go beyond 2
      expect(cubit.state.currentStep, 2);
    });

    test('validation step 1 guards age between 3 and 18', () {
      final cubit = buildCubit();
      cubit.setName('عمر');

      // Age < 3
      cubit.setBirthDate(DateTime.now().subtract(const Duration(days: 365)));
      expect(cubit.validateStep1(), false);

      // Age >= 3
      cubit.setBirthDate(DateTime.now().subtract(const Duration(days: 365 * 5)));
      expect(cubit.validateStep1(), true);
    });

    blocTest<ChildFormCubit, ChildFormState>(
      'submit in create mode emits loading then success',
      setUp: () {
        when(
          () => mockCreate(
            name: any(named: 'name'),
            birthDate: any(named: 'birthDate'),
            interests: any(named: 'interests'),
            learningStyle: any(named: 'learningStyle'),
            skillIds: any(named: 'skillIds'),
            avatar: any(named: 'avatar'),
          ),
        ).thenAnswer((_) async => const Right(_tSavedChild));
      },
      build: buildCubit,
      act: (c) {
        c.setName('عمر');
        c.setBirthDate(DateTime.now().subtract(const Duration(days: 365 * 5)));
        c.setLearningStyle(LearningStyle.visual);
        c.toggleSkill('s1');
        c.submit();
      },
      verify: (_) {
        verify(
          () => mockCreate(
            name: 'عمر',
            birthDate: any(named: 'birthDate'),
            interests: any(named: 'interests'),
            learningStyle: LearningStyle.visual,
            skillIds: ['s1'],
            avatar: any(named: 'avatar'),
          ),
        ).called(1);
      },
    );
  });
}
