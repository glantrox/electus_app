import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/auth_entity.dart';
import 'package:electus_app/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class LoginUserUseCase implements UseCase<AuthEntity, LoginUserParams> {
  final AuthRepository repository;

  LoginUserUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginUserParams params) async {
    return await repository.loginUser(params.email, params.password);
  }
}

class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
