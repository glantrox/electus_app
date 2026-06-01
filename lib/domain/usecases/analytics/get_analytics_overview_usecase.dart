import 'package:dart_either/dart_either.dart';
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
