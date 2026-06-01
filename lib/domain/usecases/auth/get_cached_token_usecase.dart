import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/auth_repository.dart';

class GetCachedTokenUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  GetCachedTokenUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await repository.getToken();
  }
}
