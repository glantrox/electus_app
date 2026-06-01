import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)

# Entity
analytics_entity = """import 'package:equatable/equatable.dart';

class AnalyticsOverviewEntity extends Equatable {
  final MetricEntity totalApplicants;
  final MetricEntity timeToHire;
  final MetricEntity offerAcceptance;
  final MetricEntity activeRoles;

  const AnalyticsOverviewEntity({
    required this.totalApplicants,
    required this.timeToHire,
    required this.offerAcceptance,
    required this.activeRoles,
  });

  @override
  List<Object?> get props => [totalApplicants, timeToHire, offerAcceptance, activeRoles];
}

class MetricEntity extends Equatable {
  final num value;
  final String? unit;
  final String trend;
  final bool? isPositiveTrend;

  const MetricEntity({
    required this.value,
    this.unit,
    required this.trend,
    this.isPositiveTrend,
  });

  @override
  List<Object?> get props => [value, unit, trend, isPositiveTrend];
}

class AnalyticsPipelineEntity extends Equatable {
  final PipelineStageEntity applied;
  final PipelineStageEntity reviewed;
  final PipelineStageEntity interviewed;

  const AnalyticsPipelineEntity({
    required this.applied,
    required this.reviewed,
    required this.interviewed,
  });

  @override
  List<Object?> get props => [applied, reviewed, interviewed];
}

class PipelineStageEntity extends Equatable {
  final int count;
  final num percentage;

  const PipelineStageEntity({
    required this.count,
    required this.percentage,
  });

  @override
  List<Object?> get props => [count, percentage];
}
"""

# Model
analytics_model = """import 'package:electus_app/domain/entities/analytics/analytics_entity.dart';

class AnalyticsOverviewModel extends AnalyticsOverviewEntity {
  const AnalyticsOverviewModel({
    required super.totalApplicants,
    required super.timeToHire,
    required super.offerAcceptance,
    required super.activeRoles,
  });

  factory AnalyticsOverviewModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverviewModel(
      totalApplicants: MetricModel.fromJson(json['totalApplicants']),
      timeToHire: MetricModel.fromJson(json['timeToHire']),
      offerAcceptance: MetricModel.fromJson(json['offerAcceptance']),
      activeRoles: MetricModel.fromJson(json['activeRoles']),
    );
  }
}

class MetricModel extends MetricEntity {
  const MetricModel({
    required super.value,
    super.unit,
    required super.trend,
    super.isPositiveTrend,
  });

  factory MetricModel.fromJson(Map<String, dynamic> json) {
    return MetricModel(
      value: json['value'] ?? 0,
      unit: json['unit'],
      trend: json['trend'] ?? '',
      isPositiveTrend: json['isPositiveTrend'],
    );
  }
}

class AnalyticsPipelineModel extends AnalyticsPipelineEntity {
  const AnalyticsPipelineModel({
    required super.applied,
    required super.reviewed,
    required super.interviewed,
  });

  factory AnalyticsPipelineModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsPipelineModel(
      applied: PipelineStageModel.fromJson(json['applied']),
      reviewed: PipelineStageModel.fromJson(json['reviewed']),
      interviewed: PipelineStageModel.fromJson(json['interviewed']),
    );
  }
}

class PipelineStageModel extends PipelineStageEntity {
  const PipelineStageModel({
    required super.count,
    required super.percentage,
  });

  factory PipelineStageModel.fromJson(Map<String, dynamic> json) {
    return PipelineStageModel(
      count: json['count'] ?? 0,
      percentage: json['percentage'] ?? 0.0,
    );
  }
}
"""

# Repository
analytics_repository = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/domain/entities/analytics/analytics_entity.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsOverviewEntity>> getAnalyticsOverview();
  Future<Either<Failure, AnalyticsPipelineEntity>> getAnalyticsPipeline();
}
"""

# DataSource
analytics_datasource = """import 'dart:convert';
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
  final String baseUrl = 'http://10.0.2.2:3000/api';

  AnalyticsRemoteDataSourceImpl({required this.client, required this.sharedPreferences});

  Future<String> _getToken() async {
    final token = sharedPreferences.getString('auth_token');
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
"""

# Repository Impl
analytics_repo_impl = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/data/datasources/analytics/analytics_remote_data_source.dart';
import 'package:electus_app/domain/entities/analytics/analytics_entity.dart';
import 'package:electus_app/domain/repositories/analytics/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AnalyticsOverviewEntity>> getAnalyticsOverview() async {
    try {
      final result = await remoteDataSource.getAnalyticsOverview();
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, AnalyticsPipelineEntity>> getAnalyticsPipeline() async {
    try {
      final result = await remoteDataSource.getAnalyticsPipeline();
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }
}
"""

# UseCases
get_overview_usecase = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/analytics/analytics_entity.dart';
import 'package:electus_app/domain/repositories/analytics/analytics_repository.dart';

class GetAnalyticsOverviewUseCase implements UseCase<AnalyticsOverviewEntity, NoParams> {
  final AnalyticsRepository repository;

  GetAnalyticsOverviewUseCase(this.repository);

  @override
  Future<Either<Failure, AnalyticsOverviewEntity>> call(NoParams params) async {
    return await repository.getAnalyticsOverview();
  }
}
"""

get_pipeline_usecase = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/analytics/analytics_entity.dart';
import 'package:electus_app/domain/repositories/analytics/analytics_repository.dart';

class GetAnalyticsPipelineUseCase implements UseCase<AnalyticsPipelineEntity, NoParams> {
  final AnalyticsRepository repository;

  GetAnalyticsPipelineUseCase(this.repository);

  @override
  Future<Either<Failure, AnalyticsPipelineEntity>> call(NoParams params) async {
    return await repository.getAnalyticsPipeline();
  }
}
"""

base = "lib"
write_file(f"{base}/domain/entities/analytics/analytics_entity.dart", analytics_entity)
write_file(f"{base}/data/models/analytics/analytics_model.dart", analytics_model)
write_file(f"{base}/domain/repositories/analytics/analytics_repository.dart", analytics_repository)
write_file(f"{base}/data/datasources/analytics/analytics_remote_data_source.dart", analytics_datasource)
write_file(f"{base}/data/repositories/analytics/analytics_repository_impl.dart", analytics_repo_impl)
write_file(f"{base}/domain/usecases/analytics/get_analytics_overview_usecase.dart", get_overview_usecase)
write_file(f"{base}/domain/usecases/analytics/get_analytics_pipeline_usecase.dart", get_pipeline_usecase)

print("Generated Analytics Data & Domain files.")
