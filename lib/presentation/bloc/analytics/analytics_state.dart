import 'package:equatable/equatable.dart';
import 'package:electus_app/domain/entities/analytics/analytics_entity.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsOverviewEntity overview;
  final AnalyticsPipelineEntity pipeline;

  const AnalyticsLoaded({
    required this.overview,
    required this.pipeline,
  });

  @override
  List<Object> get props => [overview, pipeline];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object> get props => [message];
}
