import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class CreateCandidateUseCase implements UseCase<CandidateEntity, CreateCandidateParams> {
  final CandidateRepository repository;

  CreateCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, CandidateEntity>> call(CreateCandidateParams params) async {
    return await repository.createCandidate(params.candidateData);
  }
}

class CreateCandidateParams extends Equatable {
  final Map<String, dynamic> candidateData;

  const CreateCandidateParams({required this.candidateData});

  @override
  List<Object> get props => [candidateData];
}
