import 'package:flutter_test/flutter_test.dart';
import 'package:electus_app/data/models/auth_response_model.dart';

void main() {
  group('AuthResponseModel', () {
    test('fromJson should return a valid model with token', () {
      final jsonMap = {
        'token': 'test_token',
        'user': {'id': '1', 'name': 'Test User'}
      };
      
      final result = AuthResponseModel.fromJson(jsonMap);
      
      expect(result.token, 'test_token');
      expect(result.user, {'id': '1', 'name': 'Test User'});
    });

    test('fromJson should return a valid model with accessToken', () {
      final jsonMap = {
        'accessToken': 'test_token',
        'user': {'id': '1', 'name': 'Test User'}
      };
      
      final result = AuthResponseModel.fromJson(jsonMap);
      
      expect(result.token, 'test_token');
      expect(result.user, {'id': '1', 'name': 'Test User'});
    });

    test('toJson should return a JSON map containing proper data', () {
      final model = AuthResponseModel(
        token: 'test_token',
        user: {'id': '1', 'name': 'Test User'}
      );
      
      final result = model.toJson();
      
      final expectedMap = {
        'token': 'test_token',
        'user': {'id': '1', 'name': 'Test User'}
      };
      expect(result, expectedMap);
    });
  });
}
