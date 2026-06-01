import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _DashboardPersistentHeaderDelegate(
              safeAreaTop: MediaQuery.of(context).padding.top,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: AppColor.primary,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'See full report',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    padding: EdgeInsets.zero,
                    children: const [
                      _StatCard(
                        icon: Icons.description_outlined,
                        iconColor: AppColor.iconTeal,
                        iconBgColor: AppColor.iconTealBg,
                        title: 'TOTAL CVS',
                        count: '1,248',
                        tagText: '+12% this week',
                        tagColor: AppColor.successText,
                        tagBgColor: AppColor.successBackground,
                        tagIcon: Icons.trending_up,
                      ),
                      _StatCard(
                        icon: Icons.assignment_late_outlined,
                        iconColor: AppColor.warningText,
                        iconBgColor: AppColor.warningBackground,
                        title: 'PENDING REVIEW',
                        count: '86',
                        tagText: 'Needs attention',
                        tagColor: AppColor.warningText,
                        tagBgColor: AppColor.warningBackground,
                        tagIcon: Icons.schedule,
                      ),
                      _StatCard(
                        icon: Icons.fact_check_outlined,
                        iconColor: Color(0xFF2563EB),
                        iconBgColor: Color(0xFFEFF6FF),
                        title: 'REVIEWED',
                        count: '432',
                        showProgressBar: true,
                        progressColor: Color(0xFF2563EB),
                      ),
                      _StatCard(
                        icon: Icons.forum_outlined,
                        iconColor: Color(0xFF9333EA),
                        iconBgColor: Color(0xFFFAF5FF),
                        title: 'INTERVIEWING',
                        count: '24',
                        bottomText: '4 interviews today',
                        bottomTextColor: Color(0xFF9333EA),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterPersistentHeaderDelegate(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: _CandidateCard(),
                );
              }, childCount: 5),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _DashboardPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final double safeAreaTop;

  _DashboardPersistentHeaderDelegate({required this.safeAreaTop});

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
                                color: Colors.white.withOpacity(0.15),
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
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search candidates, skills...',
                              hintStyle: TextStyle(
                                color: AppColor.textSecondary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(bottom: 12),
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
                        color: Colors.white.withOpacity(0.15),
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
  bool shouldRebuild(covariant _DashboardPersistentHeaderDelegate oldDelegate) {
    return safeAreaTop != oldDelegate.safeAreaTop;
  }
}

class _FilterPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColor
          .background, // Match background so cards hide when sliding under
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      alignment: Alignment.center,
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: const [
            _FilterChip(label: 'All Roles', isSelected: true),
            SizedBox(width: 8),
            _FilterChip(label: 'Frontend Dev', isSelected: false),
            SizedBox(width: 8),
            _FilterChip(label: 'UI/UX Designer', isSelected: false),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 68.0;

  @override
  double get minExtent => 68.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primary : AppColor.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColor.primary : const Color(0xFFE5E7EB),
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColor.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _CandidateCard extends StatelessWidget {
  const _CandidateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.surface, // Slight tint for candidate card background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Anonymous Candidate',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: AppColor.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Bachelor's • Mid-level",
                      style: TextStyle(
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColor.textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '21 Mei 2026, 16.49',
                          style: TextStyle(
                            color: AppColor.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _SkillTag(label: 'HTML'),
                        _SkillTag(label: 'CSS'),
                        _SkillTag(label: 'React'),
                        _SkillTag(label: 'TypeScript'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFECACA)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: Color(0xFFDC2626),
                              ),
                              SizedBox(width: 6),
                              Text(
                                'R - Realistic',
                                style: TextStyle(
                                  color: Color(0xFF991B1B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.successBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.auto_awesome,
                                size: 14,
                                color: AppColor.successText,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '85% Match',
                                style: TextStyle(
                                  color: AppColor.successText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColor.primary,
                              side: const BorderSide(color: AppColor.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'View Profile',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.done_all,
                              color: AppColor.textSecondary,
                            ),
                            label: const Text(
                              'Mark Done',
                              style: TextStyle(
                                color: AppColor.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
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

class _SkillTag extends StatelessWidget {
  final String label;
  const _SkillTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColor.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
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

  const _StatCard({
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColor.borderLight ?? const Color(0xFFF3F4F6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          if (tagText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: tagBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tagIcon != null) ...[
                    Icon(tagIcon, size: 12, color: tagColor),
                    const SizedBox(width: 4),
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
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.7,
                backgroundColor: const Color(0xFFF3F4F6),
                valueColor: AlwaysStoppedAnimation<Color>(progressColor!),
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}



