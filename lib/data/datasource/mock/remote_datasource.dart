abstract class RemoteDatasource {
  Future<Map<String, dynamic>> getLogin(String email, String password);
  Future<Map<String, dynamic>> getRegister(
    String fullName,
    String email,
    String password,
  );
}
