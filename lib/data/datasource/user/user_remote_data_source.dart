import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/data/models/user/user_model.dart';
import 'package:electus_app/core/config/app_config.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile({
    String? fullName,
    String? email,
    String? password,
    File? avatar,
  });
  Future<Map<String, double>> updateCultureFit(
    Map<String, double> riasecTarget,
  );
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final String baseUrl = AppConfig.apiBaseUrl;

  UserRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  Future<String> _getToken() async {
    final token = sharedPreferences.getString('CACHED_AUTH_TOKEN');
    if (token == null) throw ServerException(message: 'No auth token found');
    return token;
  }

  @override
  Future<UserModel> getUserProfile() async {
    final token = await _getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to fetch user profile');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    String? fullName,
    String? email,
    String? password,
    File? avatar,
  }) async {
    final token = await _getToken();
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/user/profile'),
    );
    request.headers['Authorization'] = 'Bearer $token';

    if (fullName != null) request.fields['fullName'] = fullName;
    if (email != null) request.fields['email'] = email;
    if (password != null) request.fields['password'] = password;

    if (avatar != null) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', avatar.path),
      );
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(responseData));
    } else {
      throw ServerException(message: 'Failed to update profile');
    }
  }

  @override
  Future<Map<String, double>> updateCultureFit(
    Map<String, double> riasecTarget,
  ) async {
    final token = await _getToken();
    final response = await client.put(
      Uri.parse('$baseUrl/user/culture-fit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(riasecTarget),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      Map<String, double> result = {};
      decoded.forEach((key, value) {
        result[key] = (value as num).toDouble();
      });
      return result;
    } else {
      throw ServerException(message: 'Failed to update culture fit');
    }
  }
}
