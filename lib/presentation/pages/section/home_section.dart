import 'package:flutter/material.dart';
import 'package:electus_app/presentation/widget/style/colors.dart';
import 'package:electus_app/presentation/widget/metric_card.dart';
import 'package:go_router/go_router.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSection(
                name: 'Alex',
                statusMessage:
                    'System analysis complete. 3 urgent matches found.',
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => context.go('/candidates'),
                      child: MetricCard(
                        icon: Icons.work_outline_rounded,
                        value: '14',
                        label: 'OPEN ROLES',
                        badgeText: 'ACTIVE',
                        badgeType: MetricBadgeType.success,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      icon: Icons.people_outline_rounded,
                      value: '1,248',
                      label: 'TOTAL CANDIDATES',
                      badgeText: '+12%',
                      badgeType: MetricBadgeType.info,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              PredictionCard(
                daysValue: '18',
                label: 'AVG TIME TO HIRE',
                statusTag: 'FAST',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final String name;
  final String statusMessage;

  const _HeaderSection({required this.name, required this.statusMessage});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Morning,\n$name',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          statusMessage,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class PredictionCard extends StatelessWidget {
  final String daysValue;
  final String label;
  final String statusTag;

  const PredictionCard({
    super.key,
    required this.daysValue,
    required this.label,
    required this.statusTag,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: customColors.primaryFixedDim,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI PREDICTION',
                    style: TextStyle(
                      color: customColors.primaryFixedDim,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$daysValue ',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'days',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: customColors.primaryFixedDim,
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              statusTag,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
