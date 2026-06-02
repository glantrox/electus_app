import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_state.dart';
import 'package:electus_app/presentation/components/common/skeleton/stat_card_skeleton.dart';
import 'package:electus_app/presentation/components/common/skeleton/shimmer_skeleton.dart';
import 'package:electus_app/presentation/components/common/skeleton/skeleton_card.dart';
import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:electus_app/presentation/bloc/profile/profile_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardHeader(),
              SizedBox(height: 32),
              _TitleSection(),
              SizedBox(height: 24),
              _MetricsGrid(),
              SizedBox(height: 32),
              _PipelineSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String name = 'Loading...';
        String avatarUrl = 'https://i.pravatar.cc/150?img=47';
        
        if (state is ProfileLoaded) {
          name = state.user.fullName.isNotEmpty ? state.user.fullName : 'Anonymous';
          if (state.user.avatarUrl.isNotEmpty) avatarUrl = state.user.avatarUrl;
        }

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => context.push('/notification'),
              icon: Icon(Icons.notifications_none_outlined),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        );
      }
    );
  }
}

class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics Overview',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Key metrics for your hiring pipeline.',
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: StatCardSkeleton()),
                  SizedBox(width: 16),
                  Expanded(child: StatCardSkeleton()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: StatCardSkeleton()),
                  SizedBox(width: 16),
                  Expanded(child: StatCardSkeleton()),
                ],
              ),
            ],
          );
        } else if (state is AnalyticsError) {
          return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
        } else if (state is AnalyticsLoaded) {
          final overview = state.overview;

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Total Applicants',
                      icon: Icons.people_outline,
                      mainValue: overview.totalApplicants.value.toString(),
                      trendText: overview.totalApplicants.trend,
                      trendIcon: overview.totalApplicants.isPositiveTrend == true ? Icons.trending_up : Icons.trending_down,
                      trendColor: overview.totalApplicants.isPositiveTrend == true ? Theme.of(context).colorScheme.primary : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      title: 'Time to Hire',
                      icon: Icons.timer_outlined,
                      mainValue: overview.timeToHire.value.toString(),
                      suffixValue: overview.timeToHire.unit != null ? ' ${overview.timeToHire.unit}' : '',
                      hasUnderline: true,
                      trendText: overview.timeToHire.trend,
                      trendIcon: overview.timeToHire.isPositiveTrend == true ? Icons.trending_down : Icons.trending_up, // lower time to hire is better
                      trendColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Offer Acceptance',
                      icon: Icons.handshake_outlined,
                      mainValue: '${overview.offerAcceptance.value}${overview.offerAcceptance.unit ?? ''}',
                      trendText: overview.offerAcceptance.trend,
                      trendIcon: Icons.horizontal_rule,
                      trendColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MetricCard(
                      title: 'Active Roles',
                      icon: Icons.work_outline,
                      mainValue: overview.activeRoles.value.toString(),
                      trendText: overview.activeRoles.trend,
                      trendIcon: Icons.info_outline,
                      trendColor: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      }
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String mainValue;
  final String suffixValue;
  final String trendText;
  final IconData trendIcon;
  final Color trendColor;
  final bool hasUnderline;

  const _MetricCard({
    required this.title,
    required this.icon,
    required this.mainValue,
    this.suffixValue = '',
    required this.trendText,
    required this.trendIcon,
    required this.trendColor,
    this.hasUnderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                mainValue,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  decoration: hasUnderline ? TextDecoration.underline : TextDecoration.none,
                  decorationColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  decorationThickness: 2,
                ),
              ),
              if (suffixValue.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4, left: 2),
                  child: Text(
                    suffixValue,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(trendIcon, size: 16, color: trendColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  trendText,
                  style: TextStyle(
                    fontSize: 13,
                    color: trendColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PipelineSection extends StatelessWidget {
  const _PipelineSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hiring Pipeline',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              ShimmerSkeleton(
                child: Column(
                  children: List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Row(
                      children: [
                        const SkeletonBox(width: 16, height: 16, borderRadius: 8),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkeletonBox(width: 100, height: 16),
                              SizedBox(height: 12),
                              SkeletonBox(width: double.infinity, height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            ],
          );
        } else if (state is AnalyticsLoaded) {
          final pipeline = state.pipeline;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hiring Pipeline',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              _PipelineStage(
                label: 'Applied',
                count: pipeline.applied.count,
                percentage: pipeline.applied.percentage.toDouble(),
                color: const Color(0xFF6366F1), // Indigo
                isFirst: true,
              ),
              _PipelineStage(
                label: 'Reviewed',
                count: pipeline.reviewed.count,
                percentage: pipeline.reviewed.percentage.toDouble(),
                color: const Color(0xFF10B981), // Emerald
              ),
              _PipelineStage(
                label: 'Interviewed',
                count: pipeline.interviewed.count,
                percentage: pipeline.interviewed.percentage.toDouble(),
                color: const Color(0xFFF59E0B), // Amber
                isLast: true,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      }
    );
  }
}

class _PipelineStage extends StatelessWidget {
  final String label;
  final int count;
  final double percentage;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const _PipelineStage({
    required this.label,
    required this.count,
    required this.percentage,
    required this.color,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline indicator
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 24,
                  color: isFirst ? Colors.transparent : const Color(0xFFE5E7EB),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : const Color(0xFFE5E7EB),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: percentage,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(percentage * 100).toInt()}% of applied',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
