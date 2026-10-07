import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:nova/core/error/error_mapper.dart";
import "package:nova/core/error/failures.dart";

void main() {
  group("ErrorMapper.fromDioException", () {
    test("connection error returns NetworkFailure", () {
      final ex = DioException(
        requestOptions: RequestOptions(path: "/test"),
        type: DioExceptionType.connectionError,
      );
      expect(ErrorMapper.fromDioException(ex), isA<NetworkFailure>());
    });

    test("receive timeout returns TimeoutFailure", () {
      final ex = DioException(
        requestOptions: RequestOptions(path: "/test"),
        type: DioExceptionType.receiveTimeout,
      );
      expect(ErrorMapper.fromDioException(ex), isA<TimeoutFailure>());
    });

    test("401 response returns UnauthorizedFailure", () {
      final ex = DioException(
        requestOptions: RequestOptions(path: "/test"),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: "/test"),
          statusCode: 401,
        ),
      );
      expect(ErrorMapper.fromDioException(ex), isA<UnauthorizedFailure>());
    });

    test("VALIDATION_ERROR returns ValidationFailure", () {
      final ex = DioException(
        requestOptions: RequestOptions(path: "/test"),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: "/test"),
          statusCode: 422,
          data: {
            "success": false,
            "error": {
              "code": "VALIDATION_ERROR",
              "message": "invalid",
              "details": {"field": "required"},
            },
          },
        ),
      );
      final failure = ErrorMapper.fromDioException(ex);
      expect(failure, isA<ValidationFailure>());
    });

    test("server error returns ServerFailure with code and message", () {
      final ex = DioException(
        requestOptions: RequestOptions(path: "/test"),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: "/test"),
          statusCode: 500,
          data: {
            "success": false,
            "error": {
              "code": "INTERNAL",
              "message": "server blew up",
            },
          },
        ),
      );
      final failure = ErrorMapper.fromDioException(ex);
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).code, "INTERNAL");
      expect(failure.message, "server blew up");
    });

    test("toArabicMessage for TimeoutFailure contains timeout text", () {
      const failure = Failure.timeout();
      final msg = ErrorMapper.toArabicMessage(failure);
      expect(msg, contains("مهلة"));
    });

    test("toArabicMessage for NetworkFailure contains connection text", () {
      const failure = Failure.network();
      final msg = ErrorMapper.toArabicMessage(failure);
      expect(msg, contains("الإنترنت"));
    });

    test("toArabicMessage for UnauthorizedFailure mentions session", () {
      const failure = Failure.unauthorized();
      final msg = ErrorMapper.toArabicMessage(failure);
      expect(msg, contains("الجلسة"));
    });
  });
}
