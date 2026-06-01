import 'package:dart_either/dart_either.dart';
import 'dart:io';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/user/user_entity.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateUserProfileUseCase implements UseCase<UserEntity, UpdateUserProfileParams> {
  final UserRepository repository;

  UpdateUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      avatar: params.avatar,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final String? fullName;
  final String? email;
  final String? password;
  final File? avatar;

  const UpdateUserProfileParams({
    this.fullName,
    this.email,
    this.password,
    this.avatar,
  });

  @override
  List<Object?> get props => [fullName, email, password, avatar];
}
