import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/domain/entities/user/user_entity.dart';
import 'dart:io';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateUserProfile({
    String? fullName,
    String? email,
    String? password,
    File? avatar,
  });
  Future<Either<Failure, Map<String, double>>> updateCultureFit(Map<String, double> riasecTarget);
}
