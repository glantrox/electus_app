import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateCultureFitUseCase implements UseCase<Map<String, double>, UpdateCultureFitParams> {
  final UserRepository repository;

  UpdateCultureFitUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, double>>> call(UpdateCultureFitParams params) async {
    return await repository.updateCultureFit(params.riasecTarget);
  }
}

class UpdateCultureFitParams extends Equatable {
  final Map<String, double> riasecTarget;

  const UpdateCultureFitParams(this.riasecTarget);

  @override
  List<Object> get props => [riasecTarget];
}
