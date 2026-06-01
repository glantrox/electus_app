import os

injection_file = 'lib/injection.dart'

with open(injection_file, 'r') as f:
    content = f.read()

imports = """
// User Profile
import 'package:electus_app/data/datasources/user/user_remote_data_source.dart';
import 'package:electus_app/data/repositories/user/user_repository_impl.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';
import 'package:electus_app/domain/usecases/user/get_user_profile_usecase.dart';
import 'package:electus_app/domain/usecases/user/update_user_profile_usecase.dart';
import 'package:electus_app/domain/usecases/user/update_culture_fit_usecase.dart';
import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';

// Notifications
import 'package:electus_app/data/datasources/notification/notification_remote_data_source.dart';
import 'package:electus_app/data/repositories/notification/notification_repository_impl.dart';
import 'package:electus_app/domain/repositories/notification/notification_repository.dart';
import 'package:electus_app/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:electus_app/domain/usecases/notification/mark_all_notifications_read_usecase.dart';
import 'package:electus_app/domain/usecases/notification/mark_notification_read_usecase.dart';
import 'package:electus_app/presentation/bloc/notification/notification_bloc.dart';

// Analytics
import 'package:electus_app/data/datasources/analytics/analytics_remote_data_source.dart';
import 'package:electus_app/data/repositories/analytics/analytics_repository_impl.dart';
import 'package:electus_app/domain/repositories/analytics/analytics_repository.dart';
import 'package:electus_app/domain/usecases/analytics/get_analytics_overview_usecase.dart';
import 'package:electus_app/domain/usecases/analytics/get_analytics_pipeline_usecase.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';
"""

# add imports just before `final di = GetIt.instance;`
content = content.replace('final di = GetIt.instance;', imports + '\nfinal di = GetIt.instance;')

data_sources = """
  di.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(client: di(), sharedPreferences: di()));
  di.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(client: di(), sharedPreferences: di()));
  di.registerLazySingleton<AnalyticsRemoteDataSource>(
      () => AnalyticsRemoteDataSourceImpl(client: di(), sharedPreferences: di()));
"""

content = content.replace('  // Repositories', data_sources + '\n  // Repositories')

repositories = """
  di.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: di()));
  di.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(remoteDataSource: di()));
  di.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(remoteDataSource: di()));
"""

content = content.replace('  // Use cases (Auth)', repositories + '\n  // Use cases (Auth)')

usecases = """
  // Use cases (Profile, Notifs, Analytics)
  di.registerLazySingleton(() => GetUserProfileUseCase(di()));
  di.registerLazySingleton(() => UpdateUserProfileUseCase(di()));
  di.registerLazySingleton(() => UpdateCultureFitUseCase(di()));

  di.registerLazySingleton(() => GetNotificationsUseCase(di()));
  di.registerLazySingleton(() => MarkAllNotificationsReadUseCase(di()));
  di.registerLazySingleton(() => MarkNotificationReadUseCase(di()));

  di.registerLazySingleton(() => GetAnalyticsOverviewUseCase(di()));
  di.registerLazySingleton(() => GetAnalyticsPipelineUseCase(di()));
"""

content = content.replace('  // BLoCs', usecases + '\n  // BLoCs')

blocs = """
  di.registerFactory(() => ProfileBloc(
        getProfile: di(),
        updateProfile: di(),
        updateCultureFit: di(),
      ));
  di.registerFactory(() => NotificationBloc(
        getNotifications: di(),
        markAllRead: di(),
        markRead: di(),
      ));
  di.registerFactory(() => AnalyticsBloc(
        getOverview: di(),
        getPipeline: di(),
      ));
"""

content = content.replace('}\n', blocs + '}\n')

with open(injection_file, 'w') as f:
    f.write(content)
print("Updated injection.dart")
