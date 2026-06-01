import 'package:dart_either/dart_either.dart';
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
