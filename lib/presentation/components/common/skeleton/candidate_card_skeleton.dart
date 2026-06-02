import 'package:flutter/material.dart';
import 'package:electus_app/presentation/components/common/skeleton/shimmer_skeleton.dart';
import 'package:electus_app/presentation/components/common/skeleton/skeleton_card.dart';

class CandidateCardSkeleton extends StatelessWidget {
  const CandidateCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonBox(width: 150, height: 18),
                      const SizedBox(height: 8),
                      const SkeletonBox(width: 100, height: 14),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          SkeletonBox(width: 70, height: 26, borderRadius: 13),
                          SizedBox(width: 8),
                          SkeletonBox(width: 60, height: 26, borderRadius: 13),
                          SizedBox(width: 8),
                          SkeletonBox(width: 80, height: 26, borderRadius: 13),
                        ],
                      ),
                    ],
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
