import 'package:shared_preferences/shared_preferences.dart';
import 'auth_local_datasource.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final SharedPreferences sharedPreferences;
  static const String cachedTokenKey = 'CACHED_AUTH_TOKEN';

  AuthLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(cachedTokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(cachedTokenKey);
  }

  @override
  Future<void> removeToken() async {
    await sharedPreferences.remove(cachedTokenKey);
  }
}
