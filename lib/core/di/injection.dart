import "package:dio/dio.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../network/auth_interceptor.dart";
import "../network/dio_client.dart";
import "../storage/prefs.dart";
import "../storage/secure_storage.dart";

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ── External ─────────────────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(),
  );

  // ── Storage ──────────────────────────────────────────────────────────────
  getIt.registerSingleton<SecureStorage>(
    SecureStorage(getIt<FlutterSecureStorage>()),
  );
  getIt.registerSingleton<Prefs>(Prefs(getIt<SharedPreferences>()));

  // ── Network ──────────────────────────────────────────────────────────────
  // [PLACEHOLDER: BASE_URL must be supplied via --dart-define=BASE_URL=https://...]
  const baseUrl = String.fromEnvironment(
    "BASE_URL",
    defaultValue: "http://localhost:3000/api/v1",
  );

  final refreshDio = DioClient.createRefreshDio();

  final authInterceptor = AuthInterceptor(
    storage: getIt<SecureStorage>(),
    refreshDio: refreshDio,
    baseUrl: baseUrl,
  );
  getIt.registerSingleton<AuthInterceptor>(authInterceptor);

  final dio = DioClient.create(
    baseUrl: baseUrl,
    authInterceptor: authInterceptor,
  );
  getIt.registerSingleton<Dio>(dio);
}

