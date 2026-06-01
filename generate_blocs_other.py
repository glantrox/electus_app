import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)

# NOTIFICATION BLOC
notification_event = """import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {}

class MarkAllNotificationsReadEvent extends NotificationEvent {}

class MarkNotificationReadEvent extends NotificationEvent {
  final String id;

  const MarkNotificationReadEvent(this.id);

  @override
  List<Object> get props => [id];
}
"""

notification_state = """import 'package:equatable/equatable.dart';
import 'package:electus_app/domain/entities/notification/notification_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}
"""

notification_bloc = """import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/usecases/notification/get_notifications_usecase.dart';
import 'package:electus_app/domain/usecases/notification/mark_all_notifications_read_usecase.dart';
import 'package:electus_app/domain/usecases/notification/mark_notification_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotifications;
  final MarkAllNotificationsReadUseCase markAllRead;
  final MarkNotificationReadUseCase markRead;

  NotificationBloc({
    required this.getNotifications,
    required this.markAllRead,
    required this.markRead,
  }) : super(NotificationInitial()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkAllNotificationsReadEvent>(_onMarkAllRead);
    on<MarkNotificationReadEvent>(_onMarkRead);
  }

  Future<void> _onFetchNotifications(FetchNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    final result = await getNotifications(NoParams());
    result.fold(
      ifLeft: (failure) => emit(NotificationError(failure.message)),
      ifRight: (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  Future<void> _onMarkAllRead(MarkAllNotificationsReadEvent event, Emitter<NotificationState> emit) async {
    final result = await markAllRead(NoParams());
    result.fold(
      ifLeft: (failure) => emit(NotificationError(failure.message)),
      ifRight: (_) {
        add(FetchNotificationsEvent());
      }
    );
  }

  Future<void> _onMarkRead(MarkNotificationReadEvent event, Emitter<NotificationState> emit) async {
    final result = await markRead(MarkNotificationReadParams(event.id));
    result.fold(
      ifLeft: (failure) => emit(NotificationError(failure.message)),
      ifRight: (_) {
        add(FetchNotificationsEvent());
      }
    );
  }
}
"""

# ANALYTICS BLOC
analytics_event = """import 'package:equatable/equatable.dart';

abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAnalyticsEvent extends AnalyticsEvent {}
"""

analytics_state = """import 'package:equatable/equatable.dart';
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
"""

analytics_bloc = """import 'package:flutter_bloc/flutter_bloc.dart';
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
"""

base = "lib"
write_file(f"{base}/presentation/bloc/notification/notification_event.dart", notification_event)
write_file(f"{base}/presentation/bloc/notification/notification_state.dart", notification_state)
write_file(f"{base}/presentation/bloc/notification/notification_bloc.dart", notification_bloc)

write_file(f"{base}/presentation/bloc/analytics/analytics_event.dart", analytics_event)
write_file(f"{base}/presentation/bloc/analytics/analytics_state.dart", analytics_state)
write_file(f"{base}/presentation/bloc/analytics/analytics_bloc.dart", analytics_bloc)

print("Generated Notification and Analytics BLoCs")
