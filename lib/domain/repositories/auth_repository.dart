import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> loginUser(String email, String password);
  Future<Either<Failure, AuthEntity>> registerUser(String fullName, String email, String password);
  Future<Either<Failure, bool>> validateToken(String token);
  Future<Either<Failure, void>> logoutUser();
  Future<Either<Failure, String?>> getToken();
}
