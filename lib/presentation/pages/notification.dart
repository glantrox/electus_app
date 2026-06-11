import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/presentation/bloc/notification/notification_bloc.dart';
import 'package:electus_app/presentation/bloc/notification/notification_event.dart';
import 'package:electus_app/presentation/bloc/notification/notification_state.dart';
import 'package:electus_app/domain/entities/notification/notification_entity.dart';
import 'package:intl/intl.dart';
import 'package:electus_app/presentation/components/common/skeleton/notification_card_skeleton.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: 4,
              itemBuilder: (context, index) => NotificationCardSkeleton(),
            );
          } else if (state is NotificationError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            );
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Text(
                  'No notifications',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _StreamHeader(
                  onMarkAllRead: () {
                    context.read<NotificationBloc>().add(
                      MarkAllNotificationsReadEvent(),
                    );
                  },
                ),
                SizedBox(height: 24),
                ...notifications.map((notif) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: _NotificationCard(
                      entity: notif,
                      onTap: () {
                        if (!notif.isRead) {
                          context.read<NotificationBloc>().add(
                            MarkNotificationReadEvent(notif.id),
                          );
                        }
                      },
                    ),
                  );
                }),
                SizedBox(height: 48),
                const _CaughtUpFooter(),
                SizedBox(height: 24),
              ],
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}

class _StreamHeader extends StatelessWidget {
  final VoidCallback onMarkAllRead;

  const _StreamHeader({required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'UPDATE STREAM',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        GestureDetector(
          onTap: onMarkAllRead,
          child: Text(
            'Mark all as read',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationEntity entity;
  final VoidCallback onTap;

  const _NotificationCard({required this.entity, required this.onTap});

  Color _getAccentColor() {
    switch (entity.type) {
      case 'INTERVIEW_REMINDER':
        return const Color(0xFF8B5CF6);
      case 'NEW_CV':
        return const Color(0xFF10B981);
      case 'STATUS_UPDATE':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  Color _getBgColor() {
    switch (entity.type) {
      case 'INTERVIEW_REMINDER':
        return const Color(0xFFF5F3FF);
      case 'NEW_CV':
        return const Color(0xFFECFDF5);
      case 'STATUS_UPDATE':
        return const Color(0xFFEFF6FF);
      default:
        return const Color(0xFFFFFBEB);
    }
  }

  IconData _getIcon() {
    switch (entity.type) {
      case 'INTERVIEW_REMINDER':
        return Icons.calendar_today_outlined;
      case 'NEW_CV':
        return Icons.cloud_upload_outlined;
      case 'STATUS_UPDATE':
        return Icons.person_outline;
      default:
        return Icons.settings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: entity.isRead
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: entity.isRead
              ? null
              : Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getBgColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIcon(), color: _getAccentColor(), size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entity.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: entity.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, h:mm a').format(entity.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    entity.content,
                    style: TextStyle(
                      color: entity.isRead
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  if (entity.badgeLabel != null &&
                      entity.badgeLabel!.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getAccentColor().withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        entity.badgeLabel!,
                        style: TextStyle(
                          color: _getAccentColor(),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaughtUpFooter extends StatelessWidget {
  const _CaughtUpFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: Theme.of(context).colorScheme.primary,
          size: 48,
        ),
        SizedBox(height: 12),
        Text(
          "You're all caught up!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Check back later for more updates.",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
