import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteCandidateUseCase implements UseCase<void, DeleteCandidateParams> {
  final CandidateRepository repository;

  DeleteCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteCandidateParams params) async {
    return await repository.deleteCandidate(params.id);
  }
}

class DeleteCandidateParams extends Equatable {
  final String id;

  const DeleteCandidateParams({required this.id});

  @override
  List<Object> get props => [id];
}
