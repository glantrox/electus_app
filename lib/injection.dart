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

final di = GetIt.instance;

Future<void> dependencyInjection() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => sharedPreferences);
  di.registerLazySingleton(() => http.Client());

  // Data sources
  di.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasourceImpl(sharedPreferences: di()));
  di.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(client: di()));
  di.registerLazySingleton<CandidateDataSource>(
      () => CandidateDataSourceImpl(client: di()));

  // Repositories
  di.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDatasource: di(), localDatasource: di()));
  di.registerLazySingleton<CandidateRepository>(
      () => CandidateRepositoryImpl(remoteDatasource: di()));

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

  // BLoCs
  di.registerFactory(() => AuthBloc(
        getCachedTokenUseCase: di(),
        validateTokenUseCase: di(),
        logoutUserUseCase: di(),
      ));
  di.registerFactory(() => LoginBloc(loginUserUseCase: di()));
  di.registerFactory(() => RegisterBloc(registerUserUseCase: di()));
}
