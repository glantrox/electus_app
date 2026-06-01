import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';

class GetCandidatesUseCase implements UseCase<List<CandidateEntity>, NoParams> {
  final CandidateRepository repository;

  GetCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(NoParams params) async {
    return await repository.getCandidates();
  }
}
