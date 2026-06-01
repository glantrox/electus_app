import 'package:flutter/material.dart';
import 'package:electus_app/core/theme/colors.dart';
import '../components/dashboard/dashboard_header.dart';
import '../components/dashboard/filter_header.dart';
import '../components/dashboard/stat_card.dart';
import '../components/dashboard/candidate_card.dart';

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
            delegate: DashboardHeaderDelegate(
              safeAreaTop: MediaQuery.of(context).padding.top,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildOverviewHeader(),
                  const SizedBox(height: 20),
                  _buildStatCardsGrid(),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: FilterHeaderDelegate(),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: CandidateCard(),
                );
              }, childCount: 5),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildOverviewHeader() {
    return Row(
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
    );
  }

  Widget _buildStatCardsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.75,
      padding: EdgeInsets.zero,
      children: const [
        StatCard(
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
        StatCard(
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
        StatCard(
          icon: Icons.fact_check_outlined,
          iconColor: Color(0xFF2563EB),
          iconBgColor: Color(0xFFEFF6FF),
          title: 'REVIEWED',
          count: '432',
          showProgressBar: true,
          progressColor: Color(0xFF2563EB),
        ),
        StatCard(
          icon: Icons.forum_outlined,
          iconColor: Color(0xFF9333EA),
          iconBgColor: Color(0xFFFAF5FF),
          title: 'INTERVIEWING',
          count: '24',
          bottomText: '4 interviews today',
          bottomTextColor: Color(0xFF9333EA),
        ),
      ],
    );
  }
}
