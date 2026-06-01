import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/usecases/candidates/get_candidates_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/search_candidates_usecase.dart';
import 'candidate_list_event.dart';
import 'candidate_list_state.dart';

class CandidateListBloc extends Bloc<CandidateListEvent, CandidateListState> {
  final GetCandidatesUseCase getCandidatesUseCase;
  final SearchCandidatesUseCase searchCandidatesUseCase;

  CandidateListBloc({
    required this.getCandidatesUseCase,
    required this.searchCandidatesUseCase,
  }) : super(CandidateListInitial()) {
    on<FetchCandidates>(_onFetchCandidates);
    on<SearchCandidatesEvent>(_onSearchCandidates);
  }

  Future<void> _onFetchCandidates(
      FetchCandidates event, Emitter<CandidateListState> emit) async {
    emit(CandidateListLoading());
    final result = await getCandidatesUseCase(NoParams());
    
    result.fold(
      ifLeft: (failure) => emit(CandidateListError(failure.message)),
      ifRight: (candidates) => emit(CandidateListLoaded(candidates)),
    );
  }

  Future<void> _onSearchCandidates(
      SearchCandidatesEvent event, Emitter<CandidateListState> emit) async {
    emit(CandidateListLoading());
    final result = await searchCandidatesUseCase(SearchCandidatesParams(query: event.query));
    
    result.fold(
      ifLeft: (failure) => emit(CandidateListError(failure.message)),
      ifRight: (candidates) => emit(CandidateListLoaded(candidates)),
    );
  }
}
