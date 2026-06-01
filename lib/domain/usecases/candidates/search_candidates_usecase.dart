import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class SearchCandidatesUseCase implements UseCase<List<CandidateEntity>, SearchCandidatesParams> {
  final CandidateRepository repository;

  SearchCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(SearchCandidatesParams params) async {
    return await repository.searchCandidates(params.query);
  }
}

class SearchCandidatesParams extends Equatable {
  final String query;

  const SearchCandidatesParams({required this.query});

  @override
  List<Object> get props => [query];
}
