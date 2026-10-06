import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';
import '../storage/prefs.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/delete_account_use_case.dart';
import '../../features/auth/domain/usecases/get_me_use_case.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/logout_use_case.dart';
import '../../features/auth/domain/usecases/register_use_case.dart';
import '../../features/auth/domain/usecases/restore_session_use_case.dart';
import '../../features/auth/domain/usecases/update_name_use_case.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

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
    'http://192.168.1.2:3000/api/v1',
    defaultValue: 'http://192.168.1.2:3000/api/v1',
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

  // ── Feature registrations ─────────────────────────────────────────────────
  registerAuthFeature(getIt);
}

/// Register auth feature dependencies.
/// Called from [configureDependencies] and can also be called in tests.
void registerAuthFeature(GetIt sl) {
  // Data
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorage: sl<SecureStorage>(),
    ),
  );
  // Register as both the domain interface and the concrete type.
  // GoRouter / AuthInterceptor need the concrete TokenProvider methods.
  sl.registerLazySingleton<AuthRepository>(
    () => sl<AuthRepositoryImpl>(),
  );

  // Use cases
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetMeUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateNameUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RestoreSessionUseCase(sl<AuthRepository>()));

  // Presentation — app-scoped singleton
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      restoreSessionUseCase: sl<RestoreSessionUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );
}
