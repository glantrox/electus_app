import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/auth_repository.dart';

class LogoutUserUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logoutUser();
  }
}
