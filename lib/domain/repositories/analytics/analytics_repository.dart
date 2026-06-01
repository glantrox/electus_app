import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/domain/entities/analytics/analytics_entity.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsOverviewEntity>> getAnalyticsOverview();
  Future<Either<Failure, AnalyticsPipelineEntity>> getAnalyticsPipeline();
}
