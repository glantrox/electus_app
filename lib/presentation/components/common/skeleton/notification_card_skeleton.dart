import 'package:flutter/material.dart';
import 'package:electus_app/presentation/components/common/skeleton/shimmer_skeleton.dart';
import 'package:electus_app/presentation/components/common/skeleton/skeleton_card.dart';

class NotificationCardSkeleton extends StatelessWidget {
  const NotificationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
              ),
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      SkeletonBox(width: 120, height: 16),
                      SkeletonBox(width: 40, height: 12),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const SkeletonBox(width: double.infinity, height: 14),
                  const SizedBox(height: 4),
                  const SkeletonBox(width: 150, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
