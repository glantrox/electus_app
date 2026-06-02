import 'package:flutter/material.dart';
import 'package:electus_app/presentation/components/common/skeleton/shimmer_skeleton.dart';
import 'package:electus_app/presentation/components/common/skeleton/skeleton_card.dart';

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(width: 80, height: 14),
            const SizedBox(height: 12),
            const SkeletonBox(width: 120, height: 32),
            const Spacer(),
            Row(
              children: [
                const SkeletonBox(width: 60, height: 24, borderRadius: 12),
                const Spacer(),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
