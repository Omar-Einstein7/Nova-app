import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nova/core/error/failures.dart';
import 'package:nova/core/storage/secure_storage.dart';
import 'package:nova/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nova/features/auth/data/models/tokens_model.dart';
import 'package:nova/features/auth/data/models/user_model.dart';
import 'package:nova/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nova/features/auth/domain/entities/user.dart';

// ── Mocks ─────────────────────────────────────────────────────────────────────

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockSecureStorage extends Mock implements SecureStorage {}

// ── Fixtures ──────────────────────────────────────────────────────────────────

const _user = UserModel(
  id: 'u1',
  name: 'Test User',
  email: 'test@nova.app',
  role: 'parent',
);

const _tokens = TokensModel(
  accessToken: 'access_abc',
  refreshToken: 'refresh_xyz',
);

const _domainUser = User(
  id: 'u1',
  name: 'Test User',
  email: 'test@nova.app',
  role: 'parent',
);

// ── Tests ──────────────────────────────────────────────────────────────────────

void main() {
  late MockAuthRemoteDataSource remote;
  late MockSecureStorage storage;
  late AuthRepositoryImpl repo;

  setUp(() {
    remote = MockAuthRemoteDataSource();
    storage = MockSecureStorage();
    repo = AuthRepositoryImpl(
      remoteDataSource: remote,
      secureStorage: storage,
    );
  });

  // ── register ────────────────────────────────────────────────────────────────

  group('register', () {
    test('saves tokens and returns User on success', () async {
      when(
        () => remote.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right((_user, _tokens)));
      when(
        () => storage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await repo.register(
        name: 'Test User',
        email: 'test@nova.app',
        password: 'secret',
      );

      expect(result, const Right<Failure, User>(_domainUser));
      verify(
        () => storage.saveTokens(
          accessToken: 'access_abc',
          refreshToken: 'refresh_xyz',
        ),
      ).called(1);
    });

    test('returns Failure and does NOT save tokens on remote error', () async {
      when(
        () => remote.register(
          name: any(named: 'name'),
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(Failure.network()));

      final result = await repo.register(
        name: 'Test',
        email: 'a@b.com',
        password: 'pw',
      );

      expect(result.isLeft(), isTrue);
      verifyNever(() => storage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          ));
    });
  });

  // ── login ───────────────────────────────────────────────────────────────────

  group('login', () {
    test('saves tokens and returns User on success', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right((_user, _tokens)));
      when(
        () => storage.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).thenAnswer((_) async {});

      final result = await repo.login(email: 'test@nova.app', password: 'pw');

      expect(result, const Right<Failure, User>(_domainUser));
      verify(
        () => storage.saveTokens(
          accessToken: 'access_abc',
          refreshToken: 'refresh_xyz',
        ),
      ).called(1);
    });
  });

  // ── logout ──────────────────────────────────────────────────────────────────

  group('logout', () {
    test('always clears tokens even when server call succeeds', () async {
      when(() => storage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_xyz');
      when(() => storage.clearTokens()).thenAnswer((_) async {});
      when(() => remote.logout(any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await repo.logout();

      expect(result.isRight(), isTrue);
      verify(() => storage.clearTokens()).called(1);
    });

    test('clears tokens even when network call fails', () async {
      when(() => storage.getRefreshToken())
          .thenAnswer((_) async => 'refresh_xyz');
      when(() => storage.clearTokens()).thenAnswer((_) async {});
      when(() => remote.logout(any()))
          .thenAnswer((_) async => const Left(Failure.network()));

      final result = await repo.logout();

      // Should still succeed locally
      expect(result.isRight(), isTrue);
      verify(() => storage.clearTokens()).called(1);
    });

    test('clears tokens when no refresh token stored', () async {
      when(() => storage.getRefreshToken()).thenAnswer((_) async => null);
      when(() => storage.clearTokens()).thenAnswer((_) async {});

      final result = await repo.logout();

      expect(result.isRight(), isTrue);
      verify(() => storage.clearTokens()).called(1);
      verifyNever(() => remote.logout(any()));
    });
  });

  // ── restoreSession ───────────────────────────────────────────────────────────

  group('restoreSession', () {
    test('returns Unauthorized immediately when no access token stored',
        () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => null);

      final result = await repo.restoreSession();

      expect(result, const Left<Failure, User>(Failure.unauthorized()));
      // No network call should be made
      verifyNever(() => remote.getMe());
    });

    test('calls getMe and returns User when token exists', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => 'token');
      when(() => remote.getMe()).thenAnswer((_) async => const Right(_user));

      final result = await repo.restoreSession();

      expect(result, const Right<Failure, User>(_domainUser));
      verify(() => remote.getMe()).called(1);
    });

    test('returns failure when getMe fails', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => 'token');
      when(() => remote.getMe())
          .thenAnswer((_) async => const Left(Failure.unauthorized()));

      final result = await repo.restoreSession();

      expect(result.isLeft(), isTrue);
    });
  });

  // ── deleteAccount ────────────────────────────────────────────────────────────

  group('deleteAccount', () {
    test('clears tokens before calling remote', () async {
      when(() => storage.clearTokens()).thenAnswer((_) async {});
      when(() => remote.deleteAccount(any()))
          .thenAnswer((_) async => const Right(unit));

      final result = await repo.deleteAccount('password');

      expect(result.isRight(), isTrue);
      verify(() => storage.clearTokens()).called(1);
    });
  });

  // ── TokenProvider ─────────────────────────────────────────────────────────

  group('TokenProvider (delegation to SecureStorage)', () {
    test('getAccessToken delegates to storage', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => 'tok');
      expect(await repo.getAccessToken(), 'tok');
    });

    test('getRefreshToken delegates to storage', () async {
      when(() => storage.getRefreshToken()).thenAnswer((_) async => 'rtok');
      expect(await repo.getRefreshToken(), 'rtok');
    });

    test('clearTokens delegates to storage', () async {
      when(() => storage.clearTokens()).thenAnswer((_) async {});
      await repo.clearTokens();
      verify(() => storage.clearTokens()).called(1);
    });
  });
}
