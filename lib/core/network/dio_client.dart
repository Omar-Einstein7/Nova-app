import "package:dio/dio.dart";
import "auth_interceptor.dart";

/// Factory that builds the primary [Dio] instance for the app.
final class DioClient {
  DioClient._();

  static Dio create({
    required String baseUrl,
    required AuthInterceptor authInterceptor,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 25),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    )
      ..interceptors.add(authInterceptor)
      ..interceptors.add(
        LogInterceptor(
          requestBody: false, // never log bodies – may contain credentials
          responseBody: false,
          logPrint: (obj) {
            // [PLACEHOLDER: Integrate a proper logger (e.g. logger package)
            //  and remove print in production]
            // ignore: avoid_print
            assert(() {
              // ignore: avoid_print
              print("[DIO] $obj");
              return true;
            }());
          },
        ),
      );
    return dio;
  }

  /// A separate Dio used only for token refresh – no interceptors.
  static Dio createRefreshDio() => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      );

  /// Override receive timeout for AI generation endpoint (40 s).
  static Options generateOptions() =>
      Options(receiveTimeout: const Duration(seconds: 40));
}
