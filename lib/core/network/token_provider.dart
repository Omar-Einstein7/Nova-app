/// Abstract interface that provides token read/write access to the
/// [AuthInterceptor]. Implemented by [AuthRepositoryImpl] to keep the
/// network layer decoupled from the auth feature.
abstract interface class TokenProvider {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> clearTokens();
}
