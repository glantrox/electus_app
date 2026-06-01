import 'package:equatable/equatable.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';

abstract class CandidateListState extends Equatable {
  const CandidateListState();

  @override
  List<Object> get props => [];
}

class CandidateListInitial extends CandidateListState {}

class CandidateListLoading extends CandidateListState {}

class CandidateListLoaded extends CandidateListState {
  final List<CandidateEntity> candidates;

  const CandidateListLoaded(this.candidates);

  @override
  List<Object> get props => [candidates];
}

class CandidateListError extends CandidateListState {
  final String message;

  const CandidateListError(this.message);

  @override
  List<Object> get props => [message];
}
