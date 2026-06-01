import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_remote_datasource.dart';
import '../../models/auth_response_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client client;
  final String baseUrl = 'http://localhost:3000';

  AuthRemoteDatasourceImpl({required this.client});

  @override
  Future<AuthResponseModel> loginUser(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'DeviceName': 'Flutter Client', 'Email': email, 'Password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  @override
  Future<AuthResponseModel> registerUser(
    String fullName,
    String email,
    String password,
  ) async {
    final response = await client.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'DeviceName': 'Flutter Client',
        'FullName': fullName,
        'Email': email,
        'Password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  @override
  Future<bool> validateToken(String token) async {
    // Note: Endpoint missing from swagger docs.
    // Assuming /auth/validate based on method name.
    final response = await client.get(
      Uri.parse('$baseUrl/auth/validate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Token invalid: ${response.body}');
    }
  }
}
