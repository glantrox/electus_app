import '../../models/auth_response_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthResponseModel> loginUser(String email, String password);
  Future<AuthResponseModel> registerUser(
    String fullName,
    String email,
    String password,
  );
  Future<bool> validateToken(String token);
}
