import 'package:flutter/material.dart';
import 'package:electus_app/core/theme/colors.dart';
import 'package:go_router/go_router.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double safeAreaTop;

  DashboardHeaderDelegate({required this.safeAreaTop});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double maxExpanded = maxExtent - minExtent;
    final double percent = (shrinkOffset / maxExpanded).clamp(0.0, 1.0);
    final double expandedPercent = 1.0 - percent;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32 * expandedPercent),
          bottomRight: Radius.circular(32 * expandedPercent),
        ),
      ),
      padding: EdgeInsets.only(top: safeAreaTop),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          if (expandedPercent > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: expandedPercent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  'https://i.pravatar.cc/150?img=47',
                                ),
                                backgroundColor: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Olan Maulana',
                                    style: TextStyle(
                                      color: AppColor.textInverse,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Opacity(
                            opacity: expandedPercent,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        context.push('/notification'),
                                    icon: const Icon(
                                      Icons.notifications_none,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  const Positioned(
                                    top: 2,
                                    right: 2,
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '1,248,123',
                        style: TextStyle(
                          color: AppColor.textInverse,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Here's your hiring overview for today.",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppColor.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search candidates, skills...',
                              hintStyle: TextStyle(
                                color: AppColor.textSecondary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 12),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColor.background,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: AppColor.textPrimary,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (percent > 0.5) ...[
                  const SizedBox(width: 12),
                  Opacity(
                    opacity: ((percent - 0.5) * 2).clamp(0.0, 1.0),
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            onPressed: () => context.push('/notification'),
                            icon: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                          ),
                          const Positioned(
                            top: 12,
                            right: 12,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => safeAreaTop + 260.0;

  @override
  double get minExtent => safeAreaTop + 80.0;

  @override
  bool shouldRebuild(covariant DashboardHeaderDelegate oldDelegate) {
    return safeAreaTop != oldDelegate.safeAreaTop;
  }
}
