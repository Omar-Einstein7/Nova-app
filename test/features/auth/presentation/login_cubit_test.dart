import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nova/core/error/failures.dart';
import 'package:nova/features/auth/domain/entities/user.dart';
import 'package:nova/features/auth/domain/usecases/login_use_case.dart';
import 'package:nova/features/auth/presentation/cubit/login_cubit.dart';
import 'package:nova/features/auth/presentation/cubit/login_state.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

const _tUser = User(
  id: 'u1',
  name: 'أحمد',
  email: 'ahmed@example.com',
  role: 'PARENT',
);

const _tEmail = 'ahmed@example.com';
const _tPassword = 'Password1';

void main() {
  late _MockLoginUseCase loginUseCase;

  setUp(() {
    loginUseCase = _MockLoginUseCase();
    registerFallbackValue(const Left<Failure, User>(Failure.unauthorized()));
  });

  LoginCubit buildCubit() =>
      LoginCubit(loginUseCase: loginUseCase);

  group('LoginCubit', () {
    test('initial state is LoginStateInitial', () {
      expect(buildCubit().state, const LoginState.initial());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [loading, success] when login succeeds',
      setUp: () {
        when(
          () => loginUseCase(email: _tEmail, password: _tPassword),
        ).thenAnswer((_) async => const Right(_tUser));
      },
      build: buildCubit,
      act: (c) => c.submit(email: _tEmail, password: _tPassword),
      expect: () => [
        const LoginState.loading(),
        LoginState.success(_tUser),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, failure] when login returns unauthorized',
      setUp: () {
        when(
          () => loginUseCase(email: _tEmail, password: _tPassword),
        ).thenAnswer((_) async => const Left(Failure.unauthorized()));
      },
      build: buildCubit,
      act: (c) => c.submit(email: _tEmail, password: _tPassword),
      expect: () => [
        const LoginState.loading(),
        const LoginState.failure(Failure.unauthorized()),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [loading, failure] when login returns network error',
      setUp: () {
        when(
          () => loginUseCase(email: _tEmail, password: _tPassword),
        ).thenAnswer(
          (_) async => const Left(Failure.network(message: 'no internet')),
        );
      },
      build: buildCubit,
      act: (c) => c.submit(email: _tEmail, password: _tPassword),
      expect: () => [
        const LoginState.loading(),
        const LoginState.failure(Failure.network(message: 'no internet')),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'does NOT double-submit when already loading',
      setUp: () {
        when(
          () => loginUseCase(email: _tEmail, password: _tPassword),
        ).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return const Right(_tUser);
        });
      },
      build: buildCubit,
      act: (c) async {
        // Fire first submit (goes to loading)
        unawaited(c.submit(email: _tEmail, password: _tPassword));
        // Immediate second submit while loading — must be a no-op
        await c.submit(email: _tEmail, password: _tPassword);
      },
      expect: () => [
        const LoginState.loading(),
        LoginState.success(_tUser),
      ],
      wait: const Duration(milliseconds: 100),
      // loginUseCase should have been called exactly once
      verify: (_) => verify(
        () => loginUseCase(email: _tEmail, password: _tPassword),
      ).called(1),
    );
  });
}

// ignore: avoid_void_async
void unawaited(Future<void> future) {}
