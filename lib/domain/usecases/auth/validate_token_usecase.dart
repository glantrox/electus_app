import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class ValidateTokenUseCase implements UseCase<bool, ValidateTokenParams> {
  final AuthRepository repository;

  ValidateTokenUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateTokenParams params) async {
    return await repository.validateToken(params.token);
  }
}

class ValidateTokenParams extends Equatable {
  final String token;

  const ValidateTokenParams({required this.token});

  @override
  List<Object> get props => [token];
}
