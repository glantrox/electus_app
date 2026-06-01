import 'package:dart_either/dart_either.dart';
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
