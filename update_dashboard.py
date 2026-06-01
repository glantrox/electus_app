import os

dashboard_path = 'lib/presentation/pages/dashboard.dart'
with open(dashboard_path, 'r') as f:
    content = f.read()

imports = """
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_event.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_state.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_state.dart';
"""

if "import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';" not in content:
    content = content.replace("import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_state.dart';", imports)

stat_grid = """
  Widget _buildStatCardsGrid() {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AnalyticsError) {
          return Center(child: Text('Failed to load metrics', style: TextStyle(color: Colors.red)));
        } else if (state is AnalyticsLoaded) {
          final overview = state.overview;
          final pipeline = state.pipeline;
          
          final totalCvs = overview.totalApplicants.value.toString();
          final pendingReview = (pipeline.applied.count - pipeline.reviewed.count).clamp(0, 9999).toString();
          final reviewedCount = pipeline.reviewed.count.toString();
          final interviewingCount = pipeline.interviewed.count.toString();
          final trendText = overview.totalApplicants.trend;

          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
            padding: EdgeInsets.zero,
            children: [
              StatCard(
                icon: Icons.description_outlined,
                iconColor: AppColor.iconTeal,
                iconBgColor: AppColor.iconTealBg,
                title: 'TOTAL CVS',
                count: totalCvs,
                tagText: trendText.isNotEmpty ? trendText : '+0% this week',
                tagColor: AppColor.successText,
                tagBgColor: AppColor.successBackground,
                tagIcon: Icons.trending_up,
              ),
              StatCard(
                icon: Icons.assignment_late_outlined,
                iconColor: AppColor.warningText,
                iconBgColor: AppColor.warningBackground,
                title: 'PENDING REVIEW',
                count: pendingReview,
                tagText: 'Needs attention',
                tagColor: AppColor.warningText,
                tagBgColor: AppColor.warningBackground,
                tagIcon: Icons.schedule,
              ),
              StatCard(
                icon: Icons.fact_check_outlined,
                iconColor: const Color(0xFF2563EB),
                iconBgColor: const Color(0xFFEFF6FF),
                title: 'REVIEWED',
                count: reviewedCount,
                showProgressBar: true,
                progressColor: const Color(0xFF2563EB),
              ),
              StatCard(
                icon: Icons.forum_outlined,
                iconColor: const Color(0xFF9333EA),
                iconBgColor: const Color(0xFFFAF5FF),
                title: 'INTERVIEWING',
                count: interviewingCount,
                bottomText: 'Check schedule',
                bottomTextColor: const Color(0xFF9333EA),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      }
    );
  }
"""

import re
content = re.sub(r'Widget _buildStatCardsGrid\(\) \{.*?(?=\n  \}\n)\n  \}', stat_grid.strip(), content, flags=re.DOTALL)

with open(dashboard_path, 'w') as f:
    f.write(content)
print("Updated dashboard.dart")
