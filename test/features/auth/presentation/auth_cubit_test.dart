import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nova/core/error/failures.dart';
import 'package:nova/core/network/session_expired_event.dart';
import 'package:nova/features/auth/domain/entities/user.dart';
import 'package:nova/features/auth/domain/usecases/logout_use_case.dart';
import 'package:nova/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:nova/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nova/features/auth/presentation/cubit/auth_state.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

// ── Fixtures ──────────────────────────────────────────────────────────────────

const _user = User(
  id: 'u1',
  name: 'Omar',
  email: 'omar@nova.app',
  role: 'parent',
);

// ── Tests ──────────────────────────────────────────────────────────────────────

void main() {
  late MockRestoreSessionUseCase restoreSession;
  late MockLogoutUseCase logout;

  setUp(() {
    restoreSession = MockRestoreSessionUseCase();
    logout = MockLogoutUseCase();
  });

  AuthCubit buildCubit() => AuthCubit(
        restoreSessionUseCase: restoreSession,
        logoutUseCase: logout,
      );

  // ── restoreSession ────────────────────────────────────────────────────────

  group('restoreSession', () {
    blocTest<AuthCubit, AuthState>(
      'emits [unknown, authenticated] when tokens are valid',
      build: buildCubit,
      setUp: () {
        when(() => restoreSession()).thenAnswer(
          (_) async => const Right(_user),
        );
      },
      act: (cubit) => cubit.restoreSession(),
      expect: () => [
        const AuthState.unknown(),
        const AuthState.authenticated(_user),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [unknown, unauthenticated] when no tokens stored',
      build: buildCubit,
      setUp: () {
        when(() => restoreSession()).thenAnswer(
          (_) async => const Left(Failure.unauthorized()),
        );
      },
      act: (cubit) => cubit.restoreSession(),
      expect: () => [
        const AuthState.unknown(),
        const AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [unknown, unauthenticated] on network failure during restore',
      build: buildCubit,
      setUp: () {
        when(() => restoreSession()).thenAnswer(
          (_) async => const Left(Failure.network()),
        );
      },
      act: (cubit) => cubit.restoreSession(),
      expect: () => [
        const AuthState.unknown(),
        const AuthState.unauthenticated(),
      ],
    );
  });

  // ── onLoggedIn ────────────────────────────────────────────────────────────

  group('onLoggedIn', () {
    blocTest<AuthCubit, AuthState>(
      'emits authenticated with the given user',
      build: buildCubit,
      act: (cubit) => cubit.onLoggedIn(_user),
      expect: () => [const AuthState.authenticated(_user)],
    );
  });

  // ── logout ────────────────────────────────────────────────────────────────

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated immediately even before network call completes',
      build: buildCubit,
      setUp: () {
        when(() => logout()).thenAnswer((_) async => const Right(unit));
      },
      act: (cubit) => cubit.logout(),
      expect: () => [const AuthState.unauthenticated()],
      verify: (_) => verify(() => logout()).called(1),
    );

    blocTest<AuthCubit, AuthState>(
      'still emits unauthenticated when logout network call fails',
      build: buildCubit,
      setUp: () {
        when(() => logout())
            .thenAnswer((_) async => const Left(Failure.network()));
      },
      act: (cubit) => cubit.logout(),
      expect: () => [const AuthState.unauthenticated()],
    );
  });

  // ── onAccountDeleted ──────────────────────────────────────────────────────

  group('onAccountDeleted', () {
    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated',
      build: buildCubit,
      act: (cubit) => cubit.onAccountDeleted(),
      expect: () => [const AuthState.unauthenticated()],
    );
  });

  // ── SessionExpired stream ─────────────────────────────────────────────────

  group('sessionExpired stream', () {
    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated when sessionExpired fires while authenticated',
      build: buildCubit,
      setUp: () {
        when(() => restoreSession())
            .thenAnswer((_) async => const Right(_user));
      },
      act: (cubit) async {
        // First get into authenticated state
        await cubit.restoreSession();
        // Then fire session expired
        SessionExpiredEvent.emit();
        // Give the stream time to deliver
        await Future<void>.delayed(const Duration(milliseconds: 50));
      },
      expect: () => [
        const AuthState.unknown(),
        const AuthState.authenticated(_user),
        const AuthState.unauthenticated(), // triggered by session expired
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'does not emit duplicate unauthenticated if already unauthenticated',
      build: buildCubit,
      act: (cubit) async {
        // Start in unknown → skip to unauthenticated manually
        cubit.onAccountDeleted();
        // Fire session expired — should be a no-op since already unauth
        SessionExpiredEvent.emit();
        await Future<void>.delayed(const Duration(milliseconds: 50));
      },
      expect: () => [
        const AuthState.unauthenticated(), // from onAccountDeleted
        // NO second unauthenticated from session expired
      ],
    );
  });

  // ── routerListenable ──────────────────────────────────────────────────────

  group('routerListenable', () {
    test('notifies listeners after restoreSession', () async {
      when(() => restoreSession()).thenAnswer((_) async => const Right(_user));
      final cubit = buildCubit();
      var notified = false;
      cubit.routerListenable.addListener(() => notified = true);

      await cubit.restoreSession();

      expect(notified, isTrue);
      cubit.close();
    });

    test('notifies listeners after logout', () async {
      when(() => logout()).thenAnswer((_) async => const Right(unit));
      final cubit = buildCubit();
      var notified = false;
      cubit.routerListenable.addListener(() => notified = true);

      await cubit.logout();

      expect(notified, isTrue);
      cubit.close();
    });
  });
}
