import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class CandidateActionEvent extends Equatable {
  const CandidateActionEvent();

  @override
  List<Object?> get props => [];
}

class CreateCandidateEvent extends CandidateActionEvent {
  final Map<String, dynamic> candidateData;

  const CreateCandidateEvent(this.candidateData);

  @override
  List<Object?> get props => [candidateData];
}

class UploadCandidateEvent extends CandidateActionEvent {
  final File file;

  const UploadCandidateEvent(this.file);

  @override
  List<Object?> get props => [file];
}

class DeleteCandidateEvent extends CandidateActionEvent {
  final String id;

  const DeleteCandidateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateCandidateStatusEvent extends CandidateActionEvent {
  final String id;
  final String status;

  const UpdateCandidateStatusEvent(this.id, this.status);

  @override
  List<Object?> get props => [id, status];
}

class InviteCandidateEvent extends CandidateActionEvent {
  final String id;

  const InviteCandidateEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteAllCandidatesEvent extends CandidateActionEvent {}

class DeleteDuplicatesEvent extends CandidateActionEvent {}

class DeleteCandidatesByStatusEvent extends CandidateActionEvent {
  final String status;

  const DeleteCandidatesByStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}
