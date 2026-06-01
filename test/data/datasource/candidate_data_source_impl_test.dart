import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:electus_app/data/datasource/candidate/candidate_data_source_impl.dart';
import 'package:electus_app/data/models/candidate_model.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockSharedPreferences extends Mock implements SharedPreferences {}
class FakeUri extends Fake implements Uri {}

void main() {
  late CandidateDataSourceImpl datasource;
  late MockHttpClient mockHttpClient;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    mockSharedPreferences = MockSharedPreferences();
    when(() => mockSharedPreferences.getString('CACHED_AUTH_TOKEN')).thenReturn('test_token');
    datasource = CandidateDataSourceImpl(client: mockHttpClient, sharedPreferences: mockSharedPreferences);
  });

  group('CandidateDataSourceImpl', () {
    final tCandidateJson = {
      'id': '123',
      'fullName': 'John Doe',
      'email': 'john@example.com',
      'phone': '1234567890',
      'reviewStatus': 'pending',
      'processingStatus': 'processed',
      'aiSummary': ['Great fit'],
      'cvText': 'Lots of experience',
      'skills': ['Dart', 'Flutter'],
      'education': 'BS CS',
      'experience': '5 years',
      'portfolioUrl': 'https://portfolio.com',
      'hasPortfolio': true,
      'matchScore': 95,
      'cvFilePath': '/path/to/cv.pdf',
    };

    test('getCandidates should return List of CandidateModel on 200', () async {
      when(() => mockHttpClient.get(
        any(),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode([tCandidateJson]), 200));

      final result = await datasource.getCandidates();

      expect(result, isA<List<CandidateModel>>());
      expect(result.first.id, '123');
    });

    test('getCandidates should throw Exception on non-200', () async {
      when(() => mockHttpClient.get(
        any(),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => http.Response('Error', 500));

      expect(() => datasource.getCandidates(), throwsException);
    });

    test('createCandidate should return CandidateModel on 200', () async {
      when(() => mockHttpClient.post(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(tCandidateJson), 200));

      final result = await datasource.createCandidate({'fullName': 'John Doe'});

      expect(result, isA<CandidateModel>());
      expect(result.fullName, 'John Doe');
    });

    test('deleteCandidate should complete normally on 200', () async {
      when(() => mockHttpClient.delete(
        any(),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => http.Response('', 200));

      expect(() => datasource.deleteCandidate('123'), returnsNormally);
    });

    test('updateCandidateStatus should return CandidateModel on 200', () async {
      when(() => mockHttpClient.patch(
        any(),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(tCandidateJson), 200));

      final result = await datasource.updateCandidateStatus('123', 'reviewed');

      expect(result, isA<CandidateModel>());
    });
  });
}
