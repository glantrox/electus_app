import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class GetCandidateStatusUseCase implements UseCase<String, GetCandidateStatusParams> {
  final CandidateRepository repository;

  GetCandidateStatusUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(GetCandidateStatusParams params) async {
    return await repository.getCandidateStatus(params.id);
  }
}

class GetCandidateStatusParams extends Equatable {
  final String id;

  const GetCandidateStatusParams({required this.id});

  @override
  List<Object> get props => [id];
}
