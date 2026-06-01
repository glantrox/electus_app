import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String content;
  final bool isRead;
  final String? badgeLabel;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.content,
    required this.isRead,
    this.badgeLabel,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, type, title, content, isRead, badgeLabel, createdAt];
}
