import 'package:equatable/equatable.dart';

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
