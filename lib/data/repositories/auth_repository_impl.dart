import 'dart:io';

import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/data/datasource/auth/auth_remote_datasource.dart';
import 'package:electus_app/data/datasource/auth/auth_local_datasource.dart';
import 'package:electus_app/domain/entities/auth_entity.dart';
import 'package:electus_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, AuthEntity>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final model = await remoteDatasource.loginUser(email, password);
      await localDatasource.cacheToken(model.token);
      return Either.right(model.toEntity());
    } on SocketException catch (e) {
      return Either.left(ConnectionFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> registerUser(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final model = await remoteDatasource.registerUser(
        fullName,
        email,
        password,
      );
      await localDatasource.cacheToken(model.token);
      return Either.right(model.toEntity());
    } on SocketException catch (e) {
      return Either.left(ConnectionFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> validateToken(String token) async {
    try {
      final result = await remoteDatasource.validateToken(token);
      return Either.right(result);
    } on SocketException catch (e) {
      return Either.left(ConnectionFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await localDatasource.removeToken();
      return const Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = await localDatasource.getToken();
      return Either.right(token);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
