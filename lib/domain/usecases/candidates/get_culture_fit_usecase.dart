import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class GetCultureFitUseCase implements UseCase<Map<String, dynamic>, GetCultureFitParams> {
  final CandidateRepository repository;

  GetCultureFitUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(GetCultureFitParams params) async {
    return await repository.getCultureFit(params.id);
  }
}

class GetCultureFitParams extends Equatable {
  final String id;

  const GetCultureFitParams({required this.id});

  @override
  List<Object> get props => [id];
}
