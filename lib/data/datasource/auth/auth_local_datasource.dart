abstract class AuthLocalDatasource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
}
