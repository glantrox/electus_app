import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class InviteCandidateUseCase implements UseCase<CandidateEntity, InviteCandidateParams> {
  final CandidateRepository repository;

  InviteCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, CandidateEntity>> call(InviteCandidateParams params) async {
    return await repository.inviteCandidate(params.id);
  }
}

class InviteCandidateParams extends Equatable {
  final String id;

  const InviteCandidateParams({required this.id});

  @override
  List<Object> get props => [id];
}
