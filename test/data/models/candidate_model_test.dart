import 'package:flutter_test/flutter_test.dart';
import 'package:electus_app/data/models/candidate_model.dart';

void main() {
  group('CandidateModel', () {
    final tHollandCodeJson = {
      'primary': 'R',
      'label': 'Realistic',
      'distribution': [
        {'code': 'R', 'label': 'Realistic', 'value': 80, 'color': 'red'}
      ]
    };

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
      'hollandCode': tHollandCodeJson,
      'education': 'BS CS',
      'experience': '5 years',
      'portfolioUrl': 'https://portfolio.com',
      'hasPortfolio': true,
      'matchScore': 95,
      'cvFilePath': '/path/to/cv.pdf',
      'embedding': [0.1, 0.2, 0.3],
      'createdAt': '2023-10-01T12:00:00.000Z'
    };

    test('fromJson should return a valid CandidateModel', () {
      final result = CandidateModel.fromJson(tCandidateJson);

      expect(result.id, '123');
      expect(result.fullName, 'John Doe');
      expect(result.skills, ['Dart', 'Flutter']);
      expect(result.hollandCode?.primary, 'R');
      expect(result.hollandCode?.distribution?.first.value, 80);
      expect(result.embedding, [0.1, 0.2, 0.3]);
      expect(result.createdAt, DateTime.parse('2023-10-01T12:00:00.000Z'));
    });

    test('toJson should return a JSON map containing proper data', () {
      final model = CandidateModel(
        id: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        reviewStatus: 'pending',
        processingStatus: 'processed',
        aiSummary: ['Great fit'],
        cvText: 'Lots of experience',
        skills: ['Dart', 'Flutter'],
        hollandCode: HollandCode(
          primary: 'R',
          label: 'Realistic',
          distribution: [
            HollandCodeDistribution(code: 'R', label: 'Realistic', value: 80, color: 'red')
          ]
        ),
        education: 'BS CS',
        experience: '5 years',
        portfolioUrl: 'https://portfolio.com',
        hasPortfolio: true,
        matchScore: 95,
        cvFilePath: '/path/to/cv.pdf',
        embedding: [0.1, 0.2, 0.3],
        createdAt: DateTime.utc(2023, 10, 1, 12)
      );

      final result = model.toJson();

      expect(result['id'], '123');
      expect(result['skills'], ['Dart', 'Flutter']);
      expect(result['hollandCode']['primary'], 'R');
      expect(result['createdAt'], '2023-10-01T12:00:00.000Z');
    });
  });
}
