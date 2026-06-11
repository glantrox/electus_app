import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String count;
  final String? tagText;
  final Color? tagColor;
  final Color? tagBgColor;
  final IconData? tagIcon;
  final String? bottomText;
  final Color? bottomTextColor;
  final bool showProgressBar;
  final Color? progressColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.count,
    this.tagText,
    this.tagColor,
    this.tagBgColor,
    this.tagIcon,
    this.bottomText,
    this.bottomTextColor,
    this.showProgressBar = false,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            count,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 8),
          if (tagText != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: tagBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tagIcon != null) ...[
                    Icon(tagIcon, size: 12, color: tagColor),
                    SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      tagText!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: tagColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (bottomText != null)
            Text(
              bottomText!,
              style: TextStyle(
                fontSize: 12,
                color: bottomTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (showProgressBar) ...[
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: 0.65,
                backgroundColor: const Color(0xFFF3F4F6),
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor ?? Theme.of(context).colorScheme.primary,
                ),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
