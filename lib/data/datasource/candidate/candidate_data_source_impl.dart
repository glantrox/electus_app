import 'dart:convert';
import 'dart:io';

import 'package:electus_app/data/datasource/candidate/candidate_data_source.dart';
import 'package:electus_app/data/models/candidate_model.dart';
import 'package:http/http.dart' as http;

class CandidateDataSourceImpl implements CandidateDataSource {
  final http.Client client;
  final String baseUrl = 'http://localhost:3000';

  CandidateDataSourceImpl({required this.client});

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    // 'Authorization': 'Bearer $token', // Add token if needed
  };

  @override
  Future<List<CandidateModel>> getCandidates() async {
    final response = await client.get(
      Uri.parse('$baseUrl/candidates'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CandidateModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get candidates: ${response.body}');
    }
  }

  @override
  Future<CandidateModel> createCandidate(
    Map<String, dynamic> candidateData,
  ) async {
    final response = await client.post(
      Uri.parse('$baseUrl/candidates'),
      headers: _headers(),
      body: jsonEncode(candidateData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CandidateModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create candidate: ${response.body}');
    }
  }

  @override
  Future<CandidateModel> uploadCandidate(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/candidates/upload'),
    );
    // request.headers.addAll({'Authorization': 'Bearer $token'});
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CandidateModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to upload candidate: ${response.body}');
    }
  }

  @override
  Future<List<CandidateModel>> searchCandidates(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/candidates/search?q=$query'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CandidateModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search candidates: ${response.body}');
    }
  }

  @override
  Future<CandidateModel> getCandidateById(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/candidates/$id'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return CandidateModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get candidate $id: ${response.body}');
    }
  }

  @override
  Future<void> deleteCandidate(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/candidates/$id'),
      headers: _headers(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete candidate $id: ${response.body}');
    }
  }

  @override
  Future<CandidateModel> updateCandidateStatus(String id, String status) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/candidates/$id/status'),
      headers: _headers(),
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CandidateModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update status for $id: ${response.body}');
    }
  }

  @override
  Future<String> getCandidateStatus(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/candidates/$id/status'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status']?.toString() ?? '';
    } else {
      throw Exception('Failed to get status for $id: ${response.body}');
    }
  }

  @override
  Future<void> deleteDuplicates() async {
    final response = await client.delete(
      Uri.parse('$baseUrl/candidates/duplicates'),
      headers: _headers(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete duplicates: ${response.body}');
    }
  }

  @override
  Future<void> deleteAllCandidates() async {
    final response = await client.delete(
      Uri.parse('$baseUrl/candidates/all'),
      headers: _headers(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete all candidates: ${response.body}');
    }
  }

  @override
  Future<void> deleteCandidatesByStatus(String status) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/candidates/status/$status'),
      headers: _headers(),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Failed to delete candidates with status $status: ${response.body}',
      );
    }
  }

  @override
  Future<CandidateModel> inviteCandidate(String id) async {
    final response = await client.post(
      Uri.parse('$baseUrl/candidates/$id/invite'),
      headers: _headers(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CandidateModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to invite candidate $id: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> getCultureFit(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/candidates/$id/culture-fit'),
      headers: _headers(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get culture fit for $id: ${response.body}');
    }
  }
}
