import "dart:async";
import "package:dio/dio.dart";
import "../storage/secure_storage.dart";
import "api_endpoints.dart";
import "session_expired_event.dart";

/// Interceptor that:
/// 1. Attaches Bearer access token to every request (except /auth/*).
/// 2. On 401 (non-auth path): performs a single token refresh using a
///    dedicated Dio instance, queues concurrent in-flight requests while
///    refreshing, and retries them all on success.
/// 3. On refresh failure: clears tokens and emits [SessionExpiredEvent].
final class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.storage,
    required this.refreshDio,
    required this.baseUrl,
  });

  final SecureStorage storage;

  /// Separate Dio instance used only for the refresh call
  /// (to avoid recursive interceptor loops).
  final Dio refreshDio;

  final String baseUrl;

  bool _isRefreshing = false;
  final _pendingRequests = <_PendingRequest>[];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthPath(options.path)) {
      final token = await storage.getAccessToken();
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final options = err.requestOptions;

    // Only intercept 401 on protected paths
    if (response?.statusCode != 401 || _isAuthPath(options.path)) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      // Queue this request to be retried once refresh finishes
      final completer = Completer<Response<dynamic>>();
      _pendingRequests
          .add(_PendingRequest(options: options, completer: completer));
      try {
        final retried = await completer.future;
        handler.resolve(retried);
      } catch (e) {
        handler.next(err);
      }
      return;
    }

    _isRefreshing = true;
    try {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken == null) {
        await _handleRefreshFailure(err, handler);
        return;
      }

      final refreshResponse = await refreshDio.post(
        "$baseUrl${ApiEndpoints.refresh}",
        data: {"refreshToken": refreshToken},
      );

      final data = refreshResponse.data as Map<String, dynamic>;
      final tokens = data["data"]["tokens"] as Map<String, dynamic>;
      final newAccess = tokens["accessToken"] as String;
      final newRefresh = tokens["refreshToken"] as String;

      await storage.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );

      // Retry all queued requests with the new access token
      for (final pending in _pendingRequests) {
        pending.options.headers["Authorization"] = "Bearer $newAccess";
        try {
          final dio = Dio(); // transient; can be injected for testability
          final retried = await dio.fetch(pending.options);
          pending.completer.complete(retried);
        } catch (e) {
          pending.completer.completeError(e);
        }
      }
      _pendingRequests.clear();

      // Retry the original request
      options.headers["Authorization"] = "Bearer $newAccess";
      final retried = await err.requestOptions.let(
        (o) async {
          final dio = Dio();
          return dio.fetch(o);
        },
      );
      handler.resolve(retried);
    } catch (_) {
      await _handleRefreshFailure(err, handler);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _handleRefreshFailure(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    await storage.clearTokens();
    for (final p in _pendingRequests) {
      p.completer.completeError(err);
    }
    _pendingRequests.clear();
    SessionExpiredEvent.emit();
    handler.next(err);
  }

  static bool _isAuthPath(String path) =>
      path.contains("/auth/") && !path.contains(ApiEndpoints.refresh);
}

final class _PendingRequest {
  _PendingRequest({required this.options, required this.completer});
  final RequestOptions options;
  final Completer<Response<dynamic>> completer;
}

extension _Let<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
