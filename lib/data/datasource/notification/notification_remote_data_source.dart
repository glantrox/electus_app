import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/data/models/notification/notification_model.dart';
import 'package:electus_app/core/config/app_config.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAllNotificationsRead();
  Future<void> markNotificationRead(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final String baseUrl = AppConfig.apiBaseUrl;

  NotificationRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  Future<String> _getToken() async {
    final token = sharedPreferences.getString('CACHED_AUTH_TOKEN');
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
