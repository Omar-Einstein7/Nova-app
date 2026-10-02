import "package:freezed_annotation/freezed_annotation.dart";

part "failures.freezed.dart";

/// Sealed failure hierarchy for the NOVA app.
@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({String? message}) = NetworkFailure;
  const factory Failure.timeout() = TimeoutFailure;
  const factory Failure.server({
    required String code,
    required String message,
    Object? details,
  }) = ServerFailure;
  const factory Failure.unauthorized() = UnauthorizedFailure;
  const factory Failure.validation({Object? details}) = ValidationFailure;
  const factory Failure.unknown({String? message}) = UnknownFailure;
}
