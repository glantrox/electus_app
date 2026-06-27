import 'dart:async';
import 'package:flutter/material.dart';

import '../components/dashboard/dashboard_header.dart';
import '../components/dashboard/filter_header.dart';
import '../components/dashboard/stat_card.dart';
import '../components/dashboard/candidate_card.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_event.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_state.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_state.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_event.dart';
import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:electus_app/presentation/bloc/profile/profile_state.dart';
import 'package:electus_app/presentation/bloc/profile/profile_event.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_state.dart';
import 'package:electus_app/presentation/components/common/skeleton/candidate_card_skeleton.dart';
import 'package:electus_app/presentation/components/common/skeleton/stat_card_skeleton.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _selectedFilter = 'Pending Review';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
    _searchController.addListener(_onSearchChanged);
    context.read<CandidateListBloc>().add(FetchCandidates());
    context.read<ProfileBloc>().add(FetchProfileEvent());
    context.read<AnalyticsBloc>().add(FetchAnalyticsEvent());
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        context.read<CandidateListBloc>().add(SearchCandidatesEvent(query));
      } else {
        context.read<CandidateListBloc>().add(FetchCandidates());
      }
    });
  }

  void _onBack() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<CandidateListBloc>().add(FetchCandidates());
  }

  void _onFilterChanged(String filter) {
    if (_selectedFilter == filter) return;
    setState(() {
      _selectedFilter = filter;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _selectedFilter = 'Pending Review';
      _searchController.clear();
    });

    context.read<CandidateListBloc>().add(FetchCandidates());
    context.read<AnalyticsBloc>().add(FetchAnalyticsEvent());
    context.read<ProfileBloc>().add(FetchProfileEvent());

    await Future.delayed(const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CandidateActionBloc, CandidateActionState>(
      listener: (context, state) {
        if (state is CandidateActionSuccess) {
          context.read<CandidateListBloc>().add(FetchCandidates());
          context.read<AnalyticsBloc>().add(FetchAnalyticsEvent());
          context.read<ProfileBloc>().add(FetchProfileEvent());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Theme.of(context).colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  return BlocBuilder<AnalyticsBloc, AnalyticsState>(
                    builder: (context, analyticsState) {
                      String userName = 'Guest';
                      String avatarUrl = '';
                      String totalApplicants = '0';

                      if (profileState is ProfileLoaded) {
                        userName = profileState.user.fullName;
                        avatarUrl = profileState.user.avatarUrl;
                      }

                      if (analyticsState is AnalyticsLoaded) {
                        totalApplicants = analyticsState
                            .overview
                            .totalApplicants
                            .value
                            .toString();
                      }

                      return SliverPersistentHeader(
                        pinned: true,
                        delegate: DashboardHeaderDelegate(
                          safeAreaTop: MediaQuery.of(context).padding.top,
                          userName: userName,
                          avatarUrl: avatarUrl,
                          totalApplicants: totalApplicants,
                          searchFocusNode: _searchFocusNode,
                          searchController: _searchController,
                          onBack: _onBack,
                        ),
                      );
                    },
                  );
                },
              ),
              if (!_searchFocusNode.hasFocus)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildOverviewHeader(),
                        SizedBox(height: 20),
                        _buildStatCardsGrid(),
                      ],
                    ),
                  ),
                ),
              SliverPersistentHeader(
                pinned: true,
                delegate: FilterHeaderDelegate(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: BlocBuilder<CandidateListBloc, CandidateListState>(
                  builder: (context, state) {
                    if (state is CandidateListLoading) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return CandidateCardSkeleton();
                        }, childCount: 3),
                      );
                    } else if (state is CandidateListError) {
                      return SliverToBoxAdapter(
                        child: Center(child: Text('Error: ${state.message}')),
                      );
                    } else if (state is CandidateListLoaded) {
                      final candidates = state.candidates.where((c) {
                        if (_selectedFilter == 'Pending Review') {
                          return c.reviewStatus == 'pending' || c.reviewStatus.isEmpty;
                        } else {
                          return c.reviewStatus == 'reviewed' || c.reviewStatus == 'done';
                        }
                      }).toList();

                      if (candidates.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32.0),
                              child: Text('No candidates found.'),
                            ),
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: CandidateCard(candidate: candidates[index]),
                          );
                        }, childCount: candidates.length),
                      );
                    }
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See full report',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: List.generate(4, (index) => StatCardSkeleton()),
          );
        } else if (state is AnalyticsError) {
          return Center(
            child: Text(
              'Failed to load metrics',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (state is AnalyticsLoaded) {
          final overview = state.overview;
          final pipeline = state.pipeline;

          final totalCvs = overview.totalApplicants.value.toString();
          final pendingReview =
              (pipeline.applied.count - pipeline.reviewed.count)
                  .clamp(0, 9999)
                  .toString();
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
                iconColor: Theme.of(context).colorScheme.onPrimaryContainer,
                iconBgColor: Theme.of(context).colorScheme.primaryContainer,
                title: 'TOTAL CVS',
                count: totalCvs,
                tagText: trendText.isNotEmpty ? trendText : '+0% this week',
                tagColor: const Color(0xFF317566),
                tagBgColor: const Color(0xFFEAF5F2),
                tagIcon: Icons.trending_up,
              ),
              StatCard(
                icon: Icons.assignment_late_outlined,
                iconColor: const Color(0xFFD97706),
                iconBgColor: const Color(0xFFFFF3E8),
                title: 'PENDING REVIEW',
                count: pendingReview,
                tagText: 'Needs attention',
                tagColor: const Color(0xFFD97706),
                tagBgColor: const Color(0xFFFFF3E8),
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
        return SizedBox.shrink();
      },
    );
  }
}
