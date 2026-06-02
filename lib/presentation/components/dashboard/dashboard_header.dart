import 'package:flutter/material.dart';
import 'package:electus_app/core/theme/colors.dart';
import 'package:go_router/go_router.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double safeAreaTop;
  final String userName;
  final String avatarUrl;
  final String totalApplicants;
  final FocusNode? searchFocusNode;
  final TextEditingController? searchController;
  final VoidCallback? onBack;

  DashboardHeaderDelegate({
    required this.safeAreaTop,
    required this.userName,
    required this.avatarUrl,
    required this.totalApplicants,
    this.searchFocusNode,
    this.searchController,
    this.onBack,
  });

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
        color: Theme.of(context).colorScheme.primary,
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
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: avatarUrl.isNotEmpty
                                    ? NetworkImage(avatarUrl)
                                    : const NetworkImage(
                                        'https://i.pravatar.cc/150?img=47',
                                      ),
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back,',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    userName,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
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
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        context.push('/notification'),
                                    icon: Icon(
                                      Icons.notifications_none,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                  Positioned(
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
                      SizedBox(height: 24),
                      Text(
                        totalApplicants == "0"
                            ? "Nobody"
                            : "$totalApplicants People",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Applied to this company.",
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        if (searchFocusNode?.hasFocus == true)
                          GestureDetector(
                            onTap: onBack,
                            child: Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.arrow_back,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.search,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Search candidates, skills...',
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (percent > 0.5) ...[
                  SizedBox(width: 12),
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
                            icon: Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
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
    return true;
  }
}
