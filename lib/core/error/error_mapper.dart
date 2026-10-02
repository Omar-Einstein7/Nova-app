import "package:dio/dio.dart";
import "failures.dart";

/// Maps DioException and server error codes to [Failure].
final class ErrorMapper {
  const ErrorMapper._();

  static Failure fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return Failure.network(message: e.message);

      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.transformTimeout:
        return const Failure.timeout();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return const Failure.unauthorized();

        // Parse backend envelope error
        final body = e.response?.data;
        if (body is Map<String, dynamic>) {
          final error = body["error"] as Map<String, dynamic>?;
          final code = error?["code"] as String? ?? "UNKNOWN";
          final message =
              error?["message"] as String? ?? "خطأ غير معروف";
          final details = error?["details"];

          if (code == "VALIDATION_ERROR") {
            return Failure.validation(details: details);
          }
          if (code == "UNAUTHORIZED") return const Failure.unauthorized();
          return Failure.server(code: code, message: message, details: details);
        }
        return Failure.server(
          code: "HTTP_$statusCode",
          message: e.message ?? "خطأ في الخادم",
        );

      case DioExceptionType.cancel:
        return const Failure.unknown(message: "cancelled");

      case DioExceptionType.badCertificate:
        return Failure.network(message: "certificate error");

      case DioExceptionType.unknown:
        return Failure.unknown(message: e.message);
    }
  }

  /// Convert [Failure] to a user-facing Arabic string.
  /// (Pre-localisation version – replaced by failureToArabicMessage once
  /// AppLocalizations is available in context.)
  static String toArabicMessage(Failure failure) {
    return failure.when(
      network: (_) => "تعذّر الاتصال بالإنترنت. تحقق من اتصالك وحاول مجدداً.",
      timeout: () => "انتهت مهلة الاتصال. يرجى المحاولة مجدداً.",
      server: (code, message, __) => "خطأ في الخادم: $message",
      unauthorized: () => "انتهت الجلسة. يرجى تسجيل الدخول مجدداً.",
      validation: (_) => "البيانات المدخلة غير صحيحة.",
      unknown: (msg) => msg ?? "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.",
    );
  }
}

