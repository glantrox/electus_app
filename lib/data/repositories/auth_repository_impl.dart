import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/data/datasource/auth/auth_remote_datasource.dart';
import 'package:electus_app/domain/entities/auth_entity.dart';
import 'package:electus_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, AuthEntity>> loginUser(String email, String password) async {
    try {
      final model = await remoteDatasource.loginUser(email, password);
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> registerUser(String fullName, String email, String password) async {
    try {
      final model = await remoteDatasource.registerUser(fullName, email, password);
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken(String token) async {
    try {
      final result = await remoteDatasource.validateToken(token);
      return Either.right(result);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
