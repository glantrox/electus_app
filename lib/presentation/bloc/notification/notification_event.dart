import 'package:equatable/equatable.dart';

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
