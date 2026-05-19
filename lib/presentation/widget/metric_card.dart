import 'package:flutter/material.dart';
import 'package:electus_app/presentation/widget/style/colors.dart';

enum MetricBadgeType { success, info }

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String badgeText;
  final MetricBadgeType badgeType;

  const MetricCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.badgeText,
    required this.badgeType,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    // Resolve dynamic colors based on the requested semantic type
    final isSuccess = badgeType == MetricBadgeType.success;
    final iconColor = isSuccess ? colorScheme.secondary : colorScheme.primary;
    final badgeBgColor = isSuccess
        ? colorScheme.secondaryContainer
        : colorScheme.primaryContainer;
    final badgeTextColor = isSuccess
        ? colorScheme.onSecondaryContainer
        : colorScheme.onPrimaryContainer;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    color: badgeTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
