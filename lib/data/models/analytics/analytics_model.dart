import 'package:electus_app/domain/entities/analytics/analytics_entity.dart';

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
