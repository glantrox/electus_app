import 'package:equatable/equatable.dart';

abstract class CandidateListEvent extends Equatable {
  const CandidateListEvent();

  @override
  List<Object> get props => [];
}

class FetchCandidates extends CandidateListEvent {}

class SearchCandidatesEvent extends CandidateListEvent {
  final String query;

  const SearchCandidatesEvent(this.query);

  @override
  List<Object> get props => [query];
}
