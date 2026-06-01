import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)

# Entity
notification_entity = """import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String content;
  final bool isRead;
  final String? badgeLabel;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    required this.isRead,
    this.badgeLabel,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, type, title, content, isRead, badgeLabel, createdAt];
}
"""

# Model
notification_model = """import 'package:electus_app/domain/entities/notification/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.content,
    required super.isRead,
    super.badgeLabel,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isRead: json['isRead'] ?? false,
      badgeLabel: json['badgeLabel'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'title': title,
      'content': content,
      'isRead': isRead,
      if (badgeLabel != null) 'badgeLabel': badgeLabel,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
"""

# Repository
notification_repository = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/domain/entities/notification/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAllNotificationsRead();
  Future<Either<Failure, void>> markNotificationRead(String id);
}
"""

# DataSource
notification_datasource = """import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/data/models/notification/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAllNotificationsRead();
  Future<void> markNotificationRead(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final String baseUrl = 'http://10.0.2.2:3000/api';

  NotificationRemoteDataSourceImpl({required this.client, required this.sharedPreferences});

  Future<String> _getToken() async {
    final token = sharedPreferences.getString('auth_token');
    if (token == null) throw ServerException(message: 'No auth token found');
    return token;
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final token = await _getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/notifications'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch notifications');
    }
  }

  @override
  Future<void> markAllNotificationsRead() async {
    final token = await _getToken();
    final response = await client.patch(
      Uri.parse('$baseUrl/notifications/mark-all-read'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to mark all as read');
    }
  }

  @override
  Future<void> markNotificationRead(String id) async {
    final token = await _getToken();
    final response = await client.patch(
      Uri.parse('$baseUrl/notifications/$id/read'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to mark notification as read');
    }
  }
}
"""

# Repository Impl
notification_repo_impl = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/data/datasources/notification/notification_remote_data_source.dart';
import 'package:electus_app/domain/entities/notification/notification_entity.dart';
import 'package:electus_app/domain/repositories/notification/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final result = await remoteDataSource.getNotifications();
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsRead() async {
    try {
      await remoteDataSource.markAllNotificationsRead();
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationRead(String id) async {
    try {
      await remoteDataSource.markNotificationRead(id);
      return const Either.right(null);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }
}
"""

# UseCases
get_notifs_usecase = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/notification/notification_entity.dart';
import 'package:electus_app/domain/repositories/notification/notification_repository.dart';

class GetNotificationsUseCase implements UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) async {
    return await repository.getNotifications();
  }
}
"""

mark_all_read_usecase = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/notification/notification_repository.dart';

class MarkAllNotificationsReadUseCase implements UseCase<void, NoParams> {
  final NotificationRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.markAllNotificationsRead();
  }
}
"""

mark_read_usecase = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/notification/notification_repository.dart';
import 'package:equatable/equatable.dart';

class MarkNotificationReadUseCase implements UseCase<void, MarkNotificationReadParams> {
  final NotificationRepository repository;

  MarkNotificationReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkNotificationReadParams params) async {
    return await repository.markNotificationRead(params.id);
  }
}

class MarkNotificationReadParams extends Equatable {
  final String id;

  const MarkNotificationReadParams(this.id);

  @override
  List<Object> get props => [id];
}
"""

base = "lib"
write_file(f"{base}/domain/entities/notification/notification_entity.dart", notification_entity)
write_file(f"{base}/data/models/notification/notification_model.dart", notification_model)
write_file(f"{base}/domain/repositories/notification/notification_repository.dart", notification_repository)
write_file(f"{base}/data/datasources/notification/notification_remote_data_source.dart", notification_datasource)
write_file(f"{base}/data/repositories/notification/notification_repository_impl.dart", notification_repo_impl)
write_file(f"{base}/domain/usecases/notification/get_notifications_usecase.dart", get_notifs_usecase)
write_file(f"{base}/domain/usecases/notification/mark_all_notifications_read_usecase.dart", mark_all_read_usecase)
write_file(f"{base}/domain/usecases/notification/mark_notification_read_usecase.dart", mark_read_usecase)

print("Generated Notification Data & Domain files.")
