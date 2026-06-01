import 'dart:io';
import '../../models/candidate_model.dart';

abstract class CandidateDataSource {
  Future<List<CandidateModel>> getCandidates();
  Future<CandidateModel> createCandidate(Map<String, dynamic> candidateData);
  Future<CandidateModel> uploadCandidate(File file);
  Future<List<CandidateModel>> searchCandidates(String query);
  Future<CandidateModel> getCandidateById(String id);
  Future<void> deleteCandidate(String id);
  Future<CandidateModel> updateCandidateStatus(String id, String status);
  Future<String> getCandidateStatus(String id);
  Future<void> deleteDuplicates();
  Future<void> deleteAllCandidates();
  Future<void> deleteCandidatesByStatus(String status);
  Future<CandidateModel> inviteCandidate(String id);
  Future<Map<String, dynamic>> getCultureFit(String id);
}
