import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteCandidatesByStatusUseCase implements UseCase<void, DeleteCandidatesByStatusParams> {
  final CandidateRepository repository;

  DeleteCandidatesByStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteCandidatesByStatusParams params) async {
    return await repository.deleteCandidatesByStatus(params.status);
  }
}

class DeleteCandidatesByStatusParams extends Equatable {
  final String status;

  const DeleteCandidatesByStatusParams({required this.status});

  @override
  List<Object> get props => [status];
}
