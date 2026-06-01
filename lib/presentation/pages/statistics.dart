import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?img=47',
          ), // Replace with actual user image
        ),
        const SizedBox(width: 12),
        const Text(
          'Olan Maulana',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.push('/notification'),
          icon: const Icon(Icons.notifications_none_outlined),
          color: AppColor.primary,
        ),
      ],
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
        const Text(
          'Analytics Overview',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Key metrics for your hiring pipeline.',
          style: TextStyle(fontSize: 16, color: AppColor.textSecondary),
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: _MetricCard(
                title: 'Total Applicants',
                icon: Icons.people_outline,
                mainValue: '1,248',
                trendText: '+12% this month',
                trendIcon: Icons.trending_up,
                trendColor: AppColor.primary,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _MetricCard(
                title: 'Time to Hire',
                icon: Icons.timer_outlined,
                mainValue: '18',
                suffixValue: ' days',
                hasUnderline: true,
                trendText: '-3 days avg',
                trendIcon: Icons.trending_down,
                trendColor: AppColor.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(
              child: _MetricCard(
                title: 'Offer Acceptance',
                icon: Icons.handshake_outlined,
                mainValue: '85%',
                trendText: 'Steady',
                trendIcon: Icons.horizontal_rule,
                trendColor: AppColor.textSecondary,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _MetricCard(
                title: 'Active Roles',
                icon: Icons.work_outline,
                mainValue: '12',
                trendText: '3 urgent',
                trendIcon: Icons.info_outline,
                trendColor: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String mainValue;
  final String? suffixValue;
  final bool hasUnderline;
  final String trendText;
  final IconData trendIcon;
  final Color trendColor;

  const _MetricCard({
    required this.title,
    required this.icon,
    required this.mainValue,
    this.suffixValue,
    this.hasUnderline = false,
    required this.trendText,
    required this.trendIcon,
    required this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, size: 20, color: AppColor.textSecondary),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                decoration: hasUnderline
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColor.iconBlue,
                            width: 3,
                          ),
                        ),
                      )
                    : null,
                child: Text(
                  mainValue,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                    height: 1.1,
                  ),
                ),
              ),
              if (suffixValue != null)
                Text(
                  suffixValue!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(trendIcon, size: 16, color: trendColor),
              const SizedBox(width: 4),
              Text(
                trendText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: trendColor,
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.filter_alt_outlined, color: AppColor.primary),
                  SizedBox(width: 8),
                  Text(
                    'Hiring Pipeline',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primary,
                  side: const BorderSide(color: AppColor.borderLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('View Details'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _PipelineRow(
            label: 'Applied',
            count: '1,248',
            percentage: 1.0,
            percentageString: '',
          ),
          const SizedBox(height: 24),
          const _PipelineRow(
            label: 'Reviewed',
            count: '680',
            percentage: 0.54,
            percentageString: '(54%)',
          ),
          const SizedBox(height: 24),
          const _PipelineRow(
            label: 'Interviewed',
            count: '145',
            percentage: 0.11,
            percentageString: '(11%)',
          ),
        ],
      ),
    );
  }
}

class _PipelineRow extends StatelessWidget {
  final String label;
  final String count;
  final double percentage;
  final String percentageString;

  const _PipelineRow({
    required this.label,
    required this.count,
    required this.percentage,
    required this.percentageString,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            Text(
              '$count $percentageString',
              style: const TextStyle(
                fontSize: 15,
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Custom progress bar to match the exact rounded styling
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 12,
            width: double.infinity,
            color: AppColor.borderLight.withValues(alpha: 0.5), // Track color
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.primaryLight, // Fill color from design
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
