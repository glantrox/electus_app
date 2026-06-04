import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Datasources
import 'package:electus_app/data/datasource/auth/auth_remote_datasource.dart';
import 'package:electus_app/data/datasource/auth/auth_remote_datasource_impl.dart';
import 'package:electus_app/data/datasource/auth/auth_local_datasource.dart';
import 'package:electus_app/data/datasource/auth/auth_local_datasource_impl.dart';
import 'package:electus_app/data/datasource/candidate/candidate_data_source.dart';
import 'package:electus_app/data/datasource/candidate/candidate_data_source_impl.dart';

// Repositories
import 'package:electus_app/domain/repositories/auth_repository.dart';
import 'package:electus_app/data/repositories/auth_repository_impl.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:electus_app/data/repositories/candidate_repository_impl.dart';

// Auth Usecases
import 'package:electus_app/domain/usecases/auth/login_user_usecase.dart';
import 'package:electus_app/domain/usecases/auth/register_user_usecase.dart';
import 'package:electus_app/domain/usecases/auth/validate_token_usecase.dart';
import 'package:electus_app/domain/usecases/auth/get_cached_token_usecase.dart';
import 'package:electus_app/domain/usecases/auth/logout_user_usecase.dart';

// BLoCs
import 'package:electus_app/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:electus_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:electus_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_bloc.dart';

// Candidate Usecases
import 'package:electus_app/domain/usecases/candidates/get_candidates_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/create_candidate_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/upload_candidate_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/search_candidates_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/get_candidate_by_id_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/delete_candidate_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/update_candidate_status_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/get_candidate_status_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/delete_duplicates_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/delete_all_candidates_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/delete_candidates_by_status_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/invite_candidate_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/get_culture_fit_usecase.dart';

// User Profile
import 'package:electus_app/data/datasource/user/user_remote_data_source.dart';
import 'package:electus_app/data/repositories/user/user_repository_impl.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';
import 'package:electus_app/domain/usecases/user/get_user_profile_usecase.dart';
import 'package:electus_app/domain/usecases/user/update_user_profile_usecase.dart';
import 'package:electus_app/domain/usecases/user/update_culture_fit_usecase.dart';
import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';

// Notifications
import 'package:electus_app/data/datasource/notification/notification_remote_data_source.dart';
import 'package:electus_app/data/repositories/notification/notification_repository_impl.dart';
import 'package:electus_app/domain/repositories/notification/notification_repository.dart';
import 'package:electus_app/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:electus_app/domain/usecases/notification/mark_all_notifications_read_usecase.dart';
import 'package:electus_app/domain/usecases/notification/mark_notification_read_usecase.dart';
import 'package:electus_app/presentation/bloc/notification/notification_bloc.dart';

// Analytics
import 'package:electus_app/data/datasource/analytics/analytics_remote_data_source.dart';
import 'package:electus_app/data/repositories/analytics/analytics_repository_impl.dart';
import 'package:electus_app/domain/repositories/analytics/analytics_repository.dart';
import 'package:electus_app/domain/usecases/analytics/get_analytics_overview_usecase.dart';
import 'package:electus_app/domain/usecases/analytics/get_analytics_pipeline_usecase.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';

final di = GetIt.instance;

Future<void> dependencyInjection() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => sharedPreferences);
  di.registerLazySingleton(() => http.Client());

  // Data sources
  di.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasourceImpl(sharedPreferences: di()),
  );
  di.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(client: di()),
  );
  di.registerLazySingleton<CandidateDataSource>(
    () => CandidateDataSourceImpl(client: di(), sharedPreferences: di()),
  );

  di.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: di(), sharedPreferences: di()),
  );
  di.registerLazySingleton<NotificationRemoteDataSource>(
    () =>
        NotificationRemoteDataSourceImpl(client: di(), sharedPreferences: di()),
  );
  di.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => AnalyticsRemoteDataSourceImpl(client: di(), sharedPreferences: di()),
  );

  // Repositories
  di.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: di(), localDatasource: di()),
  );
  di.registerLazySingleton<CandidateRepository>(
    () => CandidateRepositoryImpl(remoteDatasource: di()),
  );

  di.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: di()),
  );
  di.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: di()),
  );
  di.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(remoteDataSource: di()),
  );

  // Use cases (Auth)
  di.registerLazySingleton(() => LoginUserUseCase(di()));
  di.registerLazySingleton(() => RegisterUserUseCase(di()));
  di.registerLazySingleton(() => ValidateTokenUseCase(di()));
  di.registerLazySingleton(() => GetCachedTokenUseCase(di()));
  di.registerLazySingleton(() => LogoutUserUseCase(di()));

  // Use cases (Candidates)
  di.registerLazySingleton(() => GetCandidatesUseCase(di()));
  di.registerLazySingleton(() => CreateCandidateUseCase(di()));
  di.registerLazySingleton(() => UploadCandidateUseCase(di()));
  di.registerLazySingleton(() => SearchCandidatesUseCase(di()));
  di.registerLazySingleton(() => GetCandidateByIdUseCase(di()));
  di.registerLazySingleton(() => DeleteCandidateUseCase(di()));
  di.registerLazySingleton(() => UpdateCandidateStatusUseCase(di()));
  di.registerLazySingleton(() => GetCandidateStatusUseCase(di()));
  di.registerLazySingleton(() => DeleteDuplicatesUseCase(di()));
  di.registerLazySingleton(() => DeleteAllCandidatesUseCase(di()));
  di.registerLazySingleton(() => DeleteCandidatesByStatusUseCase(di()));
  di.registerLazySingleton(() => InviteCandidateUseCase(di()));
  di.registerLazySingleton(() => GetCultureFitUseCase(di()));

  // Use cases (Profile, Notifs, Analytics)
  di.registerLazySingleton(() => GetUserProfileUseCase(di()));
  di.registerLazySingleton(() => UpdateUserProfileUseCase(di()));
  di.registerLazySingleton(() => UpdateCultureFitUseCase(di()));

  di.registerLazySingleton(() => GetNotificationsUseCase(di()));
  di.registerLazySingleton(() => MarkAllNotificationsReadUseCase(di()));
  di.registerLazySingleton(() => MarkNotificationReadUseCase(di()));

  di.registerLazySingleton(() => GetAnalyticsOverviewUseCase(di()));
  di.registerLazySingleton(() => GetAnalyticsPipelineUseCase(di()));

  // BLoCs
  di.registerFactory(
    () => AuthBloc(
      getCachedTokenUseCase: di(),
      validateTokenUseCase: di(),
      logoutUserUseCase: di(),
    ),
  );
  di.registerFactory(() => LoginBloc(loginUserUseCase: di()));
  di.registerFactory(() => RegisterBloc(registerUserUseCase: di()));
  di.registerFactory(
    () => CandidateListBloc(
      getCandidatesUseCase: di(),
      searchCandidatesUseCase: di(),
    ),
  );
  di.registerFactory(
    () => CandidateActionBloc(
      createCandidateUseCase: di(),
      uploadCandidateUseCase: di(),
      deleteCandidateUseCase: di(),
      updateCandidateStatusUseCase: di(),
      inviteCandidateUseCase: di(),
      deleteAllCandidatesUseCase: di(),
      deleteDuplicatesUseCase: di(),
      deleteCandidatesByStatusUseCase: di(),
    ),
  );

  di.registerFactory(
    () => ProfileBloc(
      getProfile: di(),
      updateProfile: di(),
      updateCultureFit: di(),
    ),
  );
  di.registerFactory(
    () => NotificationBloc(
      getNotifications: di(),
      markAllRead: di(),
      markRead: di(),
    ),
  );
  di.registerFactory(() => AnalyticsBloc(getOverview: di(), getPipeline: di()));
}
