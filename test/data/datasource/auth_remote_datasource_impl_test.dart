import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:electus_app/data/datasource/auth/auth_remote_datasource_impl.dart';
import 'package:electus_app/data/models/auth_response_model.dart';

class MockHttpClient extends Mock implements http.Client {}
class FakeUri extends Fake implements Uri {}

void main() {
  late AuthRemoteDatasourceImpl datasource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = AuthRemoteDatasourceImpl(client: mockHttpClient);
  });

  group('AuthRemoteDatasourceImpl', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tFullName = 'Test User';
    
    final tAuthResponseJson = {
      'token': 'mock_token',
      'user': {'id': '1', 'name': 'Test'}
    };

    test('loginUser should return AuthResponseModel on successful login (200)', () async {
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(tAuthResponseJson), 200));

      final result = await datasource.loginUser(tEmail, tPassword);

      expect(result, isA<AuthResponseModel>());
      expect(result.token, 'mock_token');
    });

    test('loginUser should throw Exception on failure', () async {
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(() => datasource.loginUser(tEmail, tPassword), throwsException);
    });
    
    test('registerUser should return AuthResponseModel on successful register (201)', () async {
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(tAuthResponseJson), 201));

      final result = await datasource.registerUser(tFullName, tEmail, tPassword);

      expect(result, isA<AuthResponseModel>());
      expect(result.token, 'mock_token');
    });

    test('validateToken should return true on 200', () async {
      when(() => mockHttpClient.get(
        any(),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => http.Response('OK', 200));

      final result = await datasource.validateToken('mock_token');

      expect(result, isTrue);
    });

    test('validateToken should throw Exception on failure', () async {
      when(() => mockHttpClient.get(
        any(),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => http.Response('Invalid', 401));

      expect(() => datasource.validateToken('mock_token'), throwsException);
    });
  });
}
