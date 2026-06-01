import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      // Use ListView instead of SingleChildScrollView for better scrolling performance
      // if this list grows, though ListView.builder is required for production.
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: const [
          _StreamHeader(),
          SizedBox(height: 24),

          _SectionHeader(title: 'Today'),
          SizedBox(height: 12),
          _NotificationCard(
            accentColor: AppColor.notifPurple,
            iconBgColor: AppColor.notifPurpleBg,
            icon: Icons.calendar_today_outlined,
            title: 'Interview Reminder',
            time: '30m ago',
            content: Text(
              'Interview with Jane Doe starts in 30 minutes.',
              style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
            ),
            badgeLabel: 'Interview Prep',
          ),
          SizedBox(height: 12),
          _NotificationCard(
            accentColor: AppColor.notifGreen,
            iconBgColor: AppColor.notifGreenBg,
            icon: Icons.cloud_upload_outlined,
            title: 'New CV Uploaded',
            time: '2h ago',
            content: Text(
              'Successfully parsed 5 new CVs from recent upload.',
              style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
            ),
          ),

          SizedBox(height: 32),

          _SectionHeader(title: 'Yesterday'),
          SizedBox(height: 12),
          _NotificationCard(
            accentColor: AppColor.notifBlue,
            iconBgColor: AppColor.notifBlueBg,
            icon: Icons.person_outline,
            title: 'Candidate Status Update',
            time: 'Yesterday',
            // Pass a RichText widget for inline styling (the teal names)
            content: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: 'Michael Kim',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: '\'s profile has been reviewed and moved to '),
                  TextSpan(
                    text: 'Interview',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          _NotificationCard(
            accentColor: AppColor.notifOrange,
            iconBgColor: AppColor.notifOrangeBg,
            icon: Icons.settings_outlined,
            title: 'System Alert',
            time: 'Yesterday',
            content: Text(
              'Culture fit target updated in Account Settings.',
              style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
            ),
          ),

          SizedBox(height: 48),
          _CaughtUpFooter(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StreamHeader extends StatelessWidget {
  const _StreamHeader();

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
          onTap: () {
            // Trigger mark all read logic
          },
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

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColor.textPrimary,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Color accentColor;
  final Color iconBgColor;
  final IconData icon;
  final String title;
  final String time;
  final Widget content;
  final String? badgeLabel;

  const _NotificationCard({
    required this.accentColor,
    required this.iconBgColor,
    required this.icon,
    required this.title,
    required this.time,
    required this.content,
    this.badgeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        // Ensures the left border stretches to match dynamic content height
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Colored left border accent
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon with background
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: accentColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    // Main content column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColor.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          content,
                          if (badgeLabel != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: iconBgColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                badgeLabel!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: accentColor,
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                AppColor.successBackground, // Assuming teal background exists
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons
                .notifications_off_outlined, // Standard flutter icon closest to design
            color: AppColor.primary,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "You're all caught up for now.",
          style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
        ),
      ],
    );
  }
}
