import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/auth_interceptor.dart';
import '../network/dio_client.dart';
import '../network/environment.dart';
import '../services/crash_reporter.dart';
import '../services/logger.dart';
import '../services/tts_service.dart';
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
import '../../features/progress/data/datasources/progress_remote_data_source.dart';
import '../../features/progress/data/repositories/progress_repository_impl.dart';
import '../../features/progress/domain/repositories/progress_repository.dart';
import '../../features/progress/domain/usecases/progress_use_cases.dart';
import '../../features/progress/presentation/cubit/progress_cubit.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ── Services & Crash Reporting ───────────────────────────────────────────
  // [PLACEHOLDER: In production, swap with Sentry or FirebaseCrashlytics]
  final CrashReporter crashReporter =
      kDebugMode ? const ConsoleCrashReporter() : const NoOpCrashReporter();
  await crashReporter.initialize();
  getIt.registerSingleton<CrashReporter>(crashReporter);
  AppLogger.setCrashReporter(crashReporter);

  final TtsService ttsService = FlutterTtsService();
  getIt.registerSingleton<TtsService>(ttsService);

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
  // Configured from --dart-define=BASE_URL=... and AppConfig
  final baseUrl = AppConfig.baseUrl;

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
  registerProgressFeature(getIt);
  registerSettingsFeature(getIt);
}

/// Register auth feature dependencies.
void registerAuthFeature(GetIt sl) {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<AuthRepositoryImpl>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorage: sl<SecureStorage>(),
    ),
  );
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
  sl.registerLazySingleton<SkillsRemoteDataSource>(
    () => SkillsRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<SkillsRepositoryImpl>(
    () => SkillsRepositoryImpl(remoteDataSource: sl<SkillsRemoteDataSource>()),
  );
  sl.registerLazySingleton<SkillsRepository>(
    () => sl<SkillsRepositoryImpl>(),
  );

  sl.registerLazySingleton(() => GetSkillsUseCase(sl<SkillsRepository>()));

  sl.registerLazySingleton<SkillsCubit>(
    () => SkillsCubit(getSkillsUseCase: sl<GetSkillsUseCase>()),
  );
}

/// Register children feature dependencies.
void registerChildrenFeature(GetIt sl) {
  sl.registerLazySingleton<ChildrenRemoteDataSource>(
    () => ChildrenRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<ChildrenRepositoryImpl>(
    () => ChildrenRepositoryImpl(
        remoteDataSource: sl<ChildrenRemoteDataSource>()),
  );
  sl.registerLazySingleton<ChildrenRepository>(
    () => sl<ChildrenRepositoryImpl>(),
  );

  sl.registerLazySingleton(() => GetChildrenUseCase(sl<ChildrenRepository>()));
  sl.registerLazySingleton(() => GetChildUseCase(sl<ChildrenRepository>()));
  sl.registerLazySingleton(() => CreateChildUseCase(sl<ChildrenRepository>()));
  sl.registerLazySingleton(() => UpdateChildUseCase(sl<ChildrenRepository>()));
  sl.registerLazySingleton(() => DeleteChildUseCase(sl<ChildrenRepository>()));

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

  sl.registerLazySingleton(
      () => GenerateActivityUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(() => StartSessionUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(() => SubmitAnswerUseCase(sl<ActivityRepository>()));
  sl.registerLazySingleton(
      () => CompleteSessionUseCase(sl<ActivityRepository>()));

  sl.registerFactory<ActivityPlayerBloc>(
    () => ActivityPlayerBloc(
      generateActivity: sl<GenerateActivityUseCase>(),
      startSession: sl<StartSessionUseCase>(),
      submitAnswer: sl<SubmitAnswerUseCase>(),
      completeSession: sl<CompleteSessionUseCase>(),
    ),
  );
}

/// Register progress feature dependencies.
void registerProgressFeature(GetIt sl) {
  sl.registerLazySingleton<ProgressRemoteDataSource>(
    () => ProgressRemoteDataSource(sl<Dio>()),
  );
  sl.registerLazySingleton<ProgressRepositoryImpl>(
    () => ProgressRepositoryImpl(
        remoteDataSource: sl<ProgressRemoteDataSource>()),
  );
  sl.registerLazySingleton<ProgressRepository>(
    () => sl<ProgressRepositoryImpl>(),
  );

  sl.registerLazySingleton(
      () => GetProgressOverviewUseCase(sl<ProgressRepository>()));
  sl.registerLazySingleton(
      () => GetSkillChartUseCase(sl<ProgressRepository>()));
  sl.registerLazySingleton(() => GetSessionsUseCase(sl<ProgressRepository>()));

  sl.registerLazySingleton<ProgressCubitFactory>(
    () => ProgressCubitFactory(getOverview: sl<GetProgressOverviewUseCase>()),
  );
}

/// Register settings feature dependencies.
void registerSettingsFeature(GetIt sl) {
  sl.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(prefs: sl<Prefs>()),
  );
}
