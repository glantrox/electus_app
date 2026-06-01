import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/usecases/candidates/create_candidate_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/upload_candidate_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/delete_candidate_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/update_candidate_status_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/invite_candidate_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/delete_all_candidates_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/delete_duplicates_usecase.dart';
import 'package:electus_app/domain/usecases/candidates/delete_candidates_by_status_usecase.dart';
import 'candidate_action_event.dart';
import 'candidate_action_state.dart';

class CandidateActionBloc extends Bloc<CandidateActionEvent, CandidateActionState> {
  final CreateCandidateUseCase createCandidateUseCase;
  final UploadCandidateUseCase uploadCandidateUseCase;
  final DeleteCandidateUseCase deleteCandidateUseCase;
  final UpdateCandidateStatusUseCase updateCandidateStatusUseCase;
  final InviteCandidateUseCase inviteCandidateUseCase;
  final DeleteAllCandidatesUseCase deleteAllCandidatesUseCase;
  final DeleteDuplicatesUseCase deleteDuplicatesUseCase;
  final DeleteCandidatesByStatusUseCase deleteCandidatesByStatusUseCase;

  CandidateActionBloc({
    required this.createCandidateUseCase,
    required this.uploadCandidateUseCase,
    required this.deleteCandidateUseCase,
    required this.updateCandidateStatusUseCase,
    required this.inviteCandidateUseCase,
    required this.deleteAllCandidatesUseCase,
    required this.deleteDuplicatesUseCase,
    required this.deleteCandidatesByStatusUseCase,
  }) : super(CandidateActionInitial()) {
    on<CreateCandidateEvent>(_onCreateCandidate);
    on<UploadCandidateEvent>(_onUploadCandidate);
    on<DeleteCandidateEvent>(_onDeleteCandidate);
    on<UpdateCandidateStatusEvent>(_onUpdateCandidateStatus);
    on<InviteCandidateEvent>(_onInviteCandidate);
    on<DeleteAllCandidatesEvent>(_onDeleteAllCandidates);
    on<DeleteDuplicatesEvent>(_onDeleteDuplicates);
    on<DeleteCandidatesByStatusEvent>(_onDeleteCandidatesByStatus);
  }

  Future<void> _onCreateCandidate(
      CreateCandidateEvent event, Emitter<CandidateActionState> emit) async {
    emit(CandidateActionLoading());
    final result = await createCandidateUseCase(CreateCandidateParams(candidateData: event.candidateData));
    result.fold(
      ifLeft: (failure) => emit(CandidateActionError(failure.message)),
      ifRight: (candidate) => emit(CandidateActionSuccess('Candidate created successfully', candidate: candidate)),
    );
  }

  Future<void> _onUploadCandidate(
      UploadCandidateEvent event, Emitter<CandidateActionState> emit) async {
    emit(CandidateActionLoading());
    final result = await uploadCandidateUseCase(UploadCandidateParams(file: event.file));
    result.fold(
      ifLeft: (failure) => emit(CandidateActionError(failure.message)),
      ifRight: (candidate) => emit(CandidateActionSuccess('CV uploaded successfully', candidate: candidate)),
    );
  }

  Future<void> _onDeleteCandidate(
      DeleteCandidateEvent event, Emitter<CandidateActionState> emit) async {
    emit(CandidateActionLoading());
    final result = await deleteCandidateUseCase(DeleteCandidateParams(id: event.id));
    result.fold(
      ifLeft: (failure) => emit(CandidateActionError(failure.message)),
      ifRight: (_) => emit(const CandidateActionSuccess('Candidate deleted successfully')),
    );
  }

  Future<void> _onUpdateCandidateStatus(
      UpdateCandidateStatusEvent event, Emitter<CandidateActionState> emit) async {
    emit(CandidateActionLoading());
    final result = await updateCandidateStatusUseCase(
        UpdateCandidateStatusParams(id: event.id, status: event.status));
    result.fold(
      ifLeft: (failure) => emit(CandidateActionError(failure.message)),
      ifRight: (candidate) => emit(CandidateActionSuccess('Candidate status updated', candidate: candidate)),
    );
  }

  Future<void> _onInviteCandidate(
      InviteCandidateEvent event, Emitter<CandidateActionState> emit) async {
    emit(CandidateActionLoading());
    final result = await inviteCandidateUseCase(InviteCandidateParams(id: event.id));
    result.fold(
      ifLeft: (failure) => emit(CandidateActionError(failure.message)),
      ifRight: (candidate) => emit(CandidateActionSuccess('Candidate invited successfully', candidate: candidate)),
    );
  }

  Future<void> _onDeleteAllCandidates(
      DeleteAllCandidatesEvent event, Emitter<CandidateActionState> emit) async {
    emit(CandidateActionLoading());
    final result = await deleteAllCandidatesUseCase(NoParams());
    result.fold(
      ifLeft: (failure) => emit(CandidateActionError(failure.message)),
      ifRight: (_) => emit(const CandidateActionSuccess('All candidates deleted')),
    );
  }

  Future<void> _onDeleteDuplicates(
      DeleteDuplicatesEvent event, Emitter<CandidateActionState> emit) async {
    emit(CandidateActionLoading());
    final result = await deleteDuplicatesUseCase(NoParams());
    result.fold(
      ifLeft: (failure) => emit(CandidateActionError(failure.message)),
      ifRight: (_) => emit(const CandidateActionSuccess('Duplicate candidates deleted')),
    );
  }

  Future<void> _onDeleteCandidatesByStatus(
      DeleteCandidatesByStatusEvent event, Emitter<CandidateActionState> emit) async {
    emit(CandidateActionLoading());
    final result = await deleteCandidatesByStatusUseCase(DeleteCandidatesByStatusParams(status: event.status));
    result.fold(
      ifLeft: (failure) => emit(CandidateActionError(failure.message)),
      ifRight: (_) => emit(CandidateActionSuccess('Candidates with status ${event.status} deleted')),
    );
  }
}
