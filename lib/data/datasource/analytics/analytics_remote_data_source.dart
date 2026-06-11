import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/data/models/analytics/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsOverviewModel> getAnalyticsOverview();
  Future<AnalyticsPipelineModel> getAnalyticsPipeline();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final String baseUrl = '  http://10.0.2.2:3000';

  AnalyticsRemoteDataSourceImpl({required this.client, required this.sharedPreferences});

  Future<String> _getToken() async {
    final token = sharedPreferences.getString('CACHED_AUTH_TOKEN');
    if (token == null) throw ServerException(message: 'No auth token found');
    return token;
  }

  @override
  Future<AnalyticsOverviewModel> getAnalyticsOverview() async {
    final token = await _getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/analytics/overview'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return AnalyticsOverviewModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to fetch analytics overview');
    }
  }

  @override
  Future<AnalyticsPipelineModel> getAnalyticsPipeline() async {
    final token = await _getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/analytics/pipeline'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return AnalyticsPipelineModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to fetch analytics pipeline');
    }
  }
}
