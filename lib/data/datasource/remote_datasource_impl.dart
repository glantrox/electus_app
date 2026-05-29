import 'package:electus_app/data/datasource/mock/remote_datasource.dart';

class RemoteDatasourceImpl implements RemoteDatasource {
  @override
  Future<Map<String, dynamic>> getLogin(String email, String password) {
    // TODO: implement getLogin
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getRegister(
    String fullName,
    String email,
    String password,
  ) {
    // TODO: implement getRegister
    throw UnimplementedError();
  }
}
