import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/usecases/analytics/get_analytics_overview_usecase.dart';
import 'package:electus_app/domain/usecases/analytics/get_analytics_pipeline_usecase.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalyticsOverviewUseCase getOverview;
  final GetAnalyticsPipelineUseCase getPipeline;

  AnalyticsBloc({
    required this.getOverview,
    required this.getPipeline,
  }) : super(AnalyticsInitial()) {
    on<FetchAnalyticsEvent>(_onFetchAnalytics);
  }

  Future<void> _onFetchAnalytics(FetchAnalyticsEvent event, Emitter<AnalyticsState> emit) async {
    emit(AnalyticsLoading());
    
    final overviewResult = await getOverview(NoParams());
    final pipelineResult = await getPipeline(NoParams());

    overviewResult.fold(
      ifLeft: (failure) => emit(AnalyticsError(failure.message)),
      ifRight: (overview) {
        pipelineResult.fold(
          ifLeft: (failure) => emit(AnalyticsError(failure.message)),
          ifRight: (pipeline) => emit(AnalyticsLoaded(overview: overview, pipeline: pipeline)),
        );
      },
    );
  }
}
