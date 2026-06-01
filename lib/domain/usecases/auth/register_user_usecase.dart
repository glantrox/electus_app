import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/auth_entity.dart';
import 'package:electus_app/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class RegisterUserUseCase implements UseCase<AuthEntity, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterUserParams params) async {
    return await repository.registerUser(params.fullName, params.email, params.password);
  }
}

class RegisterUserParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const RegisterUserParams({required this.fullName, required this.email, required this.password});

  @override
  List<Object> get props => [fullName, email, password];
}
