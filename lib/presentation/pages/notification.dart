import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/presentation/bloc/notification/notification_bloc.dart';
import 'package:electus_app/presentation/bloc/notification/notification_event.dart';
import 'package:electus_app/presentation/bloc/notification/notification_state.dart';
import 'package:electus_app/domain/entities/notification/notification_entity.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.primary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: AppColor.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications', style: TextStyle(color: AppColor.textSecondary)));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _StreamHeader(
                  onMarkAllRead: () {
                    context.read<NotificationBloc>().add(MarkAllNotificationsReadEvent());
                  },
                ),
                const SizedBox(height: 24),
                ...notifications.map((notif) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _NotificationCard(
                      entity: notif,
                      onTap: () {
                        if (!notif.isRead) {
                          context.read<NotificationBloc>().add(MarkNotificationReadEvent(notif.id));
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(height: 48),
                const _CaughtUpFooter(),
                const SizedBox(height: 24),
              ],
            );
          }

          return const SizedBox.shrink();
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
        const Text(
          'UPDATE STREAM',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColor.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: onMarkAllRead,
          child: const Text(
            'Mark all as read',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.primary,
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

  const _NotificationCard({
    required this.entity,
    required this.onTap,
  });

  Color _getAccentColor() {
    switch (entity.type) {
      case 'INTERVIEW_REMINDER': return AppColor.notifPurple;
      case 'NEW_CV': return AppColor.notifGreen;
      case 'STATUS_UPDATE': return AppColor.notifBlue;
      default: return AppColor.notifOrange;
    }
  }

  Color _getBgColor() {
    switch (entity.type) {
      case 'INTERVIEW_REMINDER': return AppColor.notifPurpleBg;
      case 'NEW_CV': return AppColor.notifGreenBg;
      case 'STATUS_UPDATE': return AppColor.notifBlueBg;
      default: return AppColor.notifOrangeBg;
    }
  }

  IconData _getIcon() {
    switch (entity.type) {
      case 'INTERVIEW_REMINDER': return Icons.calendar_today_outlined;
      case 'NEW_CV': return Icons.cloud_upload_outlined;
      case 'STATUS_UPDATE': return Icons.person_outline;
      default: return Icons.settings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: entity.isRead ? AppColor.surface : AppColor.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: entity.isRead ? null : Border.all(color: AppColor.primary.withValues(alpha: 0.3), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getBgColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getIcon(), color: _getAccentColor(), size: 24),
            ),
            const SizedBox(width: 16),
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
                            fontWeight: entity.isRead ? FontWeight.w600 : FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, h:mm a').format(entity.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entity.content,
                    style: TextStyle(
                      color: entity.isRead ? AppColor.textSecondary : AppColor.textPrimary, 
                      fontSize: 14,
                    ),
                  ),
                  if (entity.badgeLabel != null && entity.badgeLabel!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
      children: const [
        Icon(Icons.check_circle_outline, color: AppColor.primary, size: 48),
        SizedBox(height: 12),
        Text(
          "You're all caught up!",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Check back later for more updates.",
          style: TextStyle(
            fontSize: 14,
            color: AppColor.textSecondary,
          ),
        ),
      ],
    );
  }
}
