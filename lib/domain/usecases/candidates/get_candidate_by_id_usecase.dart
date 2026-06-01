import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class GetCandidateByIdUseCase implements UseCase<CandidateEntity, GetCandidateByIdParams> {
  final CandidateRepository repository;

  GetCandidateByIdUseCase(this.repository);

  @override
  Future<Either<Failure, CandidateEntity>> call(GetCandidateByIdParams params) async {
    return await repository.getCandidateById(params.id);
  }
}

class GetCandidateByIdParams extends Equatable {
  final String id;

  const GetCandidateByIdParams({required this.id});

  @override
  List<Object> get props => [id];
}
