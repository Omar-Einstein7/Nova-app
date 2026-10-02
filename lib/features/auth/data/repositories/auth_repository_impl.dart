import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/token_provider.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

/// Concrete implementation of [AuthRepository].
/// Also implements [TokenProvider] so [AuthInterceptor] can refresh tokens
/// without depending on this feature directly.
final class AuthRepositoryImpl implements AuthRepository, TokenProvider {
  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  final AuthRemoteDataSource remoteDataSource;
  final SecureStorage secureStorage;

  // ── AuthRepository ────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
    return result.fold(
      Left.new,
      (pair) async {
        final (userModel, tokensModel) = pair;
        await secureStorage.saveTokens(
          accessToken: tokensModel.accessToken,
          refreshToken: tokensModel.refreshToken,
        );
        return Right(userModel.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    final result =
        await remoteDataSource.login(email: email, password: password);
    return result.fold(
      Left.new,
      (pair) async {
        final (userModel, tokensModel) = pair;
        await secureStorage.saveTokens(
          accessToken: tokensModel.accessToken,
          refreshToken: tokensModel.refreshToken,
        );
        return Right(userModel.toDomain());
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    final refreshToken = await secureStorage.getRefreshToken();
    // Always clear tokens locally first (per spec: even if network fails)
    await secureStorage.clearTokens();
    if (refreshToken == null) return const Right(unit);
    // Best-effort server-side invalidation; result is ignored locally
    await remoteDataSource.logout(refreshToken);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, User>> getMe() async {
    final result = await remoteDataSource.getMe();
    return result.map(_toUser);
  }

  @override
  Future<Either<Failure, User>> updateName(String name) async {
    final result = await remoteDataSource.updateName(name);
    return result.map(_toUser);
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount(String password) async {
    // Clear tokens optimistically before the network call
    await secureStorage.clearTokens();
    return remoteDataSource.deleteAccount(password);
  }

  @override
  Future<Either<Failure, User>> restoreSession() async {
    final accessToken = await secureStorage.getAccessToken();
    if (accessToken == null) {
      // No token stored → no network call, straight to Unauthenticated
      return const Left(Failure.unauthorized());
    }
    // Token exists → fetch profile.
    // If token is expired, AuthInterceptor will transparently refresh it.
    return getMe();
  }

  // ── TokenProvider (delegates to SecureStorage) ────────────────────────────

  @override
  Future<String?> getAccessToken() => secureStorage.getAccessToken();

  @override
  Future<String?> getRefreshToken() => secureStorage.getRefreshToken();

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) =>
      secureStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

  @override
  Future<void> clearTokens() => secureStorage.clearTokens();

  // ── Helpers ───────────────────────────────────────────────────────────────

  static User _toUser(UserModel m) =>
      User(id: m.id, name: m.name, email: m.email, role: m.role);
}
