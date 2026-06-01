import 'dart:io';
import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';
import 'package:equatable/equatable.dart';

class UploadCandidateUseCase implements UseCase<CandidateEntity, UploadCandidateParams> {
  final CandidateRepository repository;

  UploadCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, CandidateEntity>> call(UploadCandidateParams params) async {
    return await repository.uploadCandidate(params.file);
  }
}

class UploadCandidateParams extends Equatable {
  final File file;

  const UploadCandidateParams({required this.file});

  @override
  List<Object> get props => [file];
}
