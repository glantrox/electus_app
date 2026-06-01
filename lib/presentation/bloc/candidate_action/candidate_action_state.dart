import 'package:equatable/equatable.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';

abstract class CandidateActionState extends Equatable {
  const CandidateActionState();

  @override
  List<Object?> get props => [];
}

class CandidateActionInitial extends CandidateActionState {}

class CandidateActionLoading extends CandidateActionState {}

class CandidateActionSuccess extends CandidateActionState {
  final String message;
  final CandidateEntity? candidate;

  const CandidateActionSuccess(this.message, {this.candidate});

  @override
  List<Object?> get props => [message, candidate];
}

class CandidateActionError extends CandidateActionState {
  final String message;

  const CandidateActionError(this.message);

  @override
  List<Object?> get props => [message];
}
