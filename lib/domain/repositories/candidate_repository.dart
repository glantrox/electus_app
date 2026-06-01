import 'dart:io';
import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';

abstract class CandidateRepository {
  Future<Either<Failure, List<CandidateEntity>>> getCandidates();
  Future<Either<Failure, CandidateEntity>> createCandidate(Map<String, dynamic> candidateData);
  Future<Either<Failure, CandidateEntity>> uploadCandidate(File file);
  Future<Either<Failure, List<CandidateEntity>>> searchCandidates(String query);
  Future<Either<Failure, CandidateEntity>> getCandidateById(String id);
  Future<Either<Failure, void>> deleteCandidate(String id);
  Future<Either<Failure, CandidateEntity>> updateCandidateStatus(String id, String status);
  Future<Either<Failure, String>> getCandidateStatus(String id);
  Future<Either<Failure, void>> deleteDuplicates();
  Future<Either<Failure, void>> deleteAllCandidates();
  Future<Either<Failure, void>> deleteCandidatesByStatus(String status);
  Future<Either<Failure, CandidateEntity>> inviteCandidate(String id);
  Future<Either<Failure, Map<String, dynamic>>> getCultureFit(String id);
}
