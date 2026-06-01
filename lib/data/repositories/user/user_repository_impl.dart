import 'package:dart_either/dart_either.dart';
import 'dart:io';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/data/datasources/user/user_remote_data_source.dart';
import 'package:electus_app/domain/entities/user/user_entity.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final result = await remoteDataSource.getUserProfile();
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({
    String? fullName,
    String? email,
    String? password,
    File? avatar,
  }) async {
    try {
      final result = await remoteDataSource.updateUserProfile(
        fullName: fullName,
        email: email,
        password: password,
        avatar: avatar,
      );
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> updateCultureFit(Map<String, double> riasecTarget) async {
    try {
      final result = await remoteDataSource.updateCultureFit(riasecTarget);
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }
}
