import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

import '../models/tokens_model.dart';
import '../models/user_model.dart';

/// Raw network calls for all auth endpoints.
/// Returns [Either<Failure, T>] using [ApiResponse.parse] and Dio exceptions.
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Either<Failure, (UserModel, TokensModel)>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return _authCall(
      call: () => _dio.post(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
      ),
    );
  }

  Future<Either<Failure, (UserModel, TokensModel)>> login({
    required String email,
    required String password,
  }) async {
    return _authCall(
      call: () => _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      ),
    );
  }

  Future<Either<Failure, Unit>> logout(String refreshToken) async {
    try {
      await _dio.post(
        ApiEndpoints.logout,
        data: {'refreshToken': refreshToken},
      );
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> getMe() async {
    try {
      final response = await _dio.get(ApiEndpoints.me);
      final body = response.data as Map<String, dynamic>;
      return ApiResponse.parse(
          body, (d) => UserModel.fromJson(d as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> updateName(String name) async {
    try {
      final response = await _dio.patch(ApiEndpoints.me, data: {'name': name});
      final body = response.data as Map<String, dynamic>;
      return ApiResponse.parse(
          body, (d) => UserModel.fromJson(d as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  Future<Either<Failure, Unit>> deleteAccount(String password) async {
    try {
      await _dio.delete(ApiEndpoints.me, data: {'password': password});
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Shared helper for register/login which share the same response shape.
  Future<Either<Failure, (UserModel, TokensModel)>> _authCall({
    required Future<Response<dynamic>> Function() call,
  }) async {
    try {
      final response = await call();
      final body = response.data as Map<String, dynamic>;
      return ApiResponse.parse(body, (d) {
        final data = d as Map<String, dynamic>;
        final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
        final tokens =
            TokensModel.fromJson(data['tokens'] as Map<String, dynamic>);
        return (user, tokens);
      });
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  Failure _mapDio(DioException e) {
    final status = e.response?.statusCode;
    if (status == 401) return const Failure.unauthorized();
    if (e.type == DioExceptionType.connectionError) {
      return Failure.network(message: e.message);
    }
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionTimeout) {
      return const Failure.timeout();
    }
    final body = e.response?.data;
    if (body is Map<String, dynamic>) {
      final err = body['error'] as Map<String, dynamic>?;
      final code = err?['code'] as String? ?? 'UNKNOWN';
      final message = err?['message'] as String? ?? 'خطأ في الخادم';
      if (code == 'VALIDATION_ERROR') {
        return Failure.validation(details: err?['details']);
      }
      return Failure.server(code: code, message: message);
    }
    return Failure.unknown(message: e.message);
  }
}
