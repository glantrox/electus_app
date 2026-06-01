import 'package:flutter_bloc/flutter_bloc.dart';
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
