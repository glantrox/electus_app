import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateCandidateStatusUseCase implements UseCase<CandidateEntity, UpdateCandidateStatusParams> {
  final CandidateRepository repository;

  UpdateCandidateStatusUseCase(this.repository);

  @override
  Future<Either<Failure, CandidateEntity>> call(UpdateCandidateStatusParams params) async {
    return await repository.updateCandidateStatus(params.id, params.status);
  }
}

class UpdateCandidateStatusParams extends Equatable {
  final String id;
  final String status;

  const UpdateCandidateStatusParams({required this.id, required this.status});

  @override
  List<Object> get props => [id, status];
}
