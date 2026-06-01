import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';

class DeleteAllCandidatesUseCase implements UseCase<void, NoParams> {
  final CandidateRepository repository;

  DeleteAllCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.deleteAllCandidates();
  }
}
