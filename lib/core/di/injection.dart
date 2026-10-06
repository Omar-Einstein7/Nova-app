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
import '../../features/skills/data/datasources/skills_remote_data_source.dart';
import '../../features/skills/data/repositories/skills_repository_impl.dart';
import '../../features/skills/domain/repositories/skills_repository.dart';
import '../../features/skills/domain/usecases/get_skills_use_case.dart';
import '../../features/skills/presentation/cubit/skills_cubit.dart';
import '../../features/children/data/datasources/children_remote_data_source.dart';
import '../../features/children/data/repositories/children_repository_impl.dart';
import '../../features/children/domain/repositories/children_repository.dart';
import '../../features/children/domain/usecases/children_use_cases.dart';
import '../../features/children/presentation/cubit/children_list_cubit.dart';
import '../../features/children/presentation/cubit/child_form_cubit.dart';
import '../../features/home/presentation/cubit/dashboard_cubit.dart';
import '../../features/activity/data/datasources/activity_remote_data_source.dart';
import '../../features/activity/data/datasources/fake_activity_data_source.dart';
import '../../features/activity/data/repositories/activity_repository_impl.dart';
import '../../features/activity/domain/repositories/activity_repository.dart';
import '../../features/activity/domain/usecases/activity_use_cases.dart';
import '../../features/activity/presentation/bloc/activity_player_bloc.dart';

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
  registerSkillsFeature(getIt);
  registerChildrenFeature(getIt);
  registerActivityFeature(getIt);
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

/// Register skills feature dependencies.
void registerSkillsFeature(GetIt sl) {
  // Data
  sl.registerLazySingleton<SkillsRemoteDataSource>(
    () => SkillsRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<SkillsRepositoryImpl>(
    () => SkillsRepositoryImpl(remoteDataSource: sl<SkillsRemoteDataSource>()),
  );
  sl.registerLazySingleton<SkillsRepository>(
    () => sl<SkillsRepositoryImpl>(),
  );

  // Domain
  sl.registerLazySingleton(() => GetSkillsUseCase(sl<SkillsRepository>()));

  // Presentation — cached for session
  sl.registerLazySingleton<SkillsCubit>(
    () => SkillsCubit(getSkillsUseCase: sl<GetSkillsUseCase>()),
  );
}

/// Register children feature dependencies.
void registerChildrenFeature(GetIt sl) {
  // Data
  sl.registerLazySingleton<ChildrenRemoteDataSource>(
    () => ChildrenRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<ChildrenRepositoryImpl>(
    () => ChildrenRepositoryImpl(remoteDataSource: sl<ChildrenRemoteDataSource>()),
  );
  sl.registerLazySingleton<ChildrenRepository>(
    () => sl<ChildrenRepositoryImpl>(),
  );

  // Domain use cases
  sl.registerLazySingleton(() => GetChildrenUseCase(sl<ChildrenRepository>()));
  sl.registerLazySingleton(() => GetChildUseCase(sl<ChildrenRepository>()));
  sl.registerLazySingleton(() => CreateChildUseCase(sl<ChildrenRepository>()));
  sl.registerLazySingleton(() => UpdateChildUseCase(sl<ChildrenRepository>()));
  sl.registerLazySingleton(() => DeleteChildUseCase(sl<ChildrenRepository>()));

  // Presentation
  sl.registerFactory<ChildrenListCubit>(
    () => ChildrenListCubit(
      getChildren: sl<GetChildrenUseCase>(),
      deleteChild: sl<DeleteChildUseCase>(),
    ),
  );
  sl.registerLazySingleton<ChildFormCubitFactory>(
    () => ChildFormCubitFactory(
      createChild: sl<CreateChildUseCase>(),
      updateChild: sl<UpdateChildUseCase>(),
    ),
  );
  sl.registerLazySingleton<DashboardCubitFactory>(
    () => DashboardCubitFactory(
      dataSource: sl<ChildrenRemoteDataSource>(),
    ),
  );
}

/// Register activity feature dependencies.
void registerActivityFeature(GetIt sl) {
  // Data
  sl.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<FakeActivityDataSource>(
    () => FakeActivityDataSource(),
  );
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(
      remoteDataSource: sl<ActivityRemoteDataSource>(),
      fakeDataSource: sl<FakeActivityDataSource>(),
    ),
  );

  // Domain
  sl.registerLazySingleton(() => GenerateActivityUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(() => StartSessionUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(() => SubmitAnswerUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(() => CompleteSessionUseCase(sl<ActivityRepository>()));

  // Presentation — factory so each page gets a fresh Bloc
  sl.registerFactory<ActivityPlayerBloc>(
    () => ActivityPlayerBloc(
      generateActivity: sl<GenerateActivityUseCase>(),
      startSession: sl<StartSessionUseCase>(),
      submitAnswer: sl<SubmitAnswerUseCase>(),
      completeSession: sl<CompleteSessionUseCase>(),
    ),
  );
}
