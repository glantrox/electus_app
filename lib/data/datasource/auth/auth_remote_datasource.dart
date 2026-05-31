abstract class AuthRemoteDatasource {
  Future<void> loginUser(String email, String password);
  Future<void> registerUser(String fullName, String email, String password);
  Future<void> validateToken(String token);
}
