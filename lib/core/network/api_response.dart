import "package:fpdart/fpdart.dart";
import "../error/error.dart";

/// Parsed server envelope.
final class ApiResponse<T> {
  const ApiResponse({required this.success, this.data, this.error});

  final bool success;
  final T? data;
  final String? error;

  /// Converts the raw JSON [Map] returned by DioClient into Either.
  static Either<Failure, T> parse<T>(
    Map<String, dynamic> json,
    T Function(dynamic data) fromData,
  ) {
    final success = json["success"] as bool? ?? false;
    if (!success) {
      final err = json["error"] as Map<String, dynamic>?;
      final code = err?["code"] as String? ?? "UNKNOWN";
      final message = err?["message"] as String? ?? "خطأ غير معروف";
      final details = err?["details"];
      if (code == "VALIDATION_ERROR") {
        return Left(Failure.validation(details: details));
      }
      if (code == "UNAUTHORIZED") return const Left(Failure.unauthorized());
      return Left(Failure.server(code: code, message: message, details: details));
    }
    try {
      return Right(fromData(json["data"]));
    } catch (e) {
      return Left(Failure.unknown(message: "Parse error: $e"));
    }
  }
}
