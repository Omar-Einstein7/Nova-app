import "package:dio/dio.dart";
import "failures.dart";

/// Converts any [Failure] to a clear, calm, user-facing Arabic message.
/// Includes dedicated offline detection messaging for network failures.
String failureToArabicMessage(Failure failure) {
  return failure.when(
    network: (_) =>
        "لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة والمحاولة مجدداً 📶",
    timeout: () => "انتهت مهلة الانتظار. يرجى المحاولة مرة أخرى.",
    server: (code, message, details) {
      if (code == "CONFLICT") {
        return message.isNotEmpty ? message : "هذا العنصر موجود بالفعل.";
      }
      if (code == "NOT_FOUND") {
        return "لم يتم العثور على البيانات المطلوبة.";
      }
      if (code == "RATE_LIMITED") {
        return "يرجى الانتظار قليلاً قبل المحاولة مجدداً.";
      }
      return message.isNotEmpty
          ? message
          : "خطأ في الخادم، يرجى المحاولة لاحقاً.";
    },
    unauthorized: () => "انتهت صلاحية الجلسة. يرجى تسجيل الدخول مجدداً.",
    validation: (details) {
      if (details != null && details.toString().isNotEmpty) {
        return "يرجى مراجعة البيانات المدخلة: $details";
      }
      return "يرجى التحقق من صحة البيانات المدخلة.";
    },
    unknown: (msg) => msg?.isNotEmpty == true
        ? msg!
        : "حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.",
  );
}

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
          final message = error?["message"] as String? ?? "خطأ غير معروف";
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
  static String toArabicMessage(Failure failure) =>
      failureToArabicMessage(failure);
}
