import 'dart:io';
import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/data/datasource/candidate/candidate_data_source.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/domain/repositories/candidate_repository.dart';

class CandidateRepositoryImpl implements CandidateRepository {
  final CandidateDataSource remoteDatasource;

  CandidateRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<CandidateEntity>>> getCandidates() async {
    try {
      final models = await remoteDatasource.getCandidates();
      return Either.right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> createCandidate(Map<String, dynamic> candidateData) async {
    try {
      final model = await remoteDatasource.createCandidate(candidateData);
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> uploadCandidate(File file) async {
    try {
      final model = await remoteDatasource.uploadCandidate(file);
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CandidateEntity>>> searchCandidates(String query) async {
    try {
      final models = await remoteDatasource.searchCandidates(query);
      return Either.right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> getCandidateById(String id) async {
    try {
      final model = await remoteDatasource.getCandidateById(id);
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCandidate(String id) async {
    try {
      await remoteDatasource.deleteCandidate(id);
      return Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> updateCandidateStatus(String id, String status) async {
    try {
      final model = await remoteDatasource.updateCandidateStatus(id, status);
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCandidateStatus(String id) async {
    try {
      final status = await remoteDatasource.getCandidateStatus(id);
      return Either.right(status);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDuplicates() async {
    try {
      await remoteDatasource.deleteDuplicates();
      return Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllCandidates() async {
    try {
      await remoteDatasource.deleteAllCandidates();
      return Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCandidatesByStatus(String status) async {
    try {
      await remoteDatasource.deleteCandidatesByStatus(status);
      return Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CandidateEntity>> inviteCandidate(String id) async {
    try {
      final model = await remoteDatasource.inviteCandidate(id);
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCultureFit(String id) async {
    try {
      final fit = await remoteDatasource.getCultureFit(id);
      return Either.right(fit);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
