import 'package:flutter/material.dart';
import 'package:electus_app/presentation/widget/style/colors.dart';

class CandidatePage extends StatefulWidget {
  const CandidatePage({super.key});

  @override
  State<CandidatePage> createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isBlindScreeningActive = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _SearchBar(controller: _searchController),
                  const SizedBox(height: 16),
                  _BlindScreeningToggle(
                    isActive: _isBlindScreeningActive,
                    onChanged: (val) =>
                        setState(() => _isBlindScreeningActive = val),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  CandidateCard(
                    name: 'Sarah Chen',
                    id: '#8492-A',
                    role: 'Senior AI Architect',
                    matchPercentage: 98,
                    isBlind: _isBlindScreeningActive,
                    standardSkills: const ['TensorFlow', 'System Design'],
                    highlightedSkills: const ['Neural Networks'],
                    traits: const [
                      TraitData(
                        icon: Icons.psychology_outlined,
                        label: 'Enterprising',
                      ),
                      TraitData(
                        icon: Icons.location_on_outlined,
                        label: 'Remote',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CandidateCard(
                    name: 'Marcus J.',
                    id: '#7103-B',
                    role: 'Lead Data Scientist',
                    matchPercentage: 85,
                    isBlind: _isBlindScreeningActive,
                    standardSkills: const [
                      'Python',
                      'SQL',
                      'Predictive Modeling',
                    ],
                    highlightedSkills: const [],
                    traits: const [
                      TraitData(
                        icon: Icons.psychology_outlined,
                        label: 'INTP - Thinker',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Sub-Components ---

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return TextField(
      controller: controller,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: 'Query talent pool...',
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.surfaceContainerHigh),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      ),
    );
  }
}

class _BlindScreeningToggle extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const _BlindScreeningToggle({
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.surfaceContainerHigh),
      ),
      child: Row(
        children: [
          Icon(
            isActive
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: isActive
                ? customColors.primaryFixedDim
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blind Screening',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Bias reduction active',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: onChanged,
            activeColor: customColors.onPrimaryFixed,
            activeTrackColor: customColors.primaryFixedDim,
            inactiveThumbColor: colorScheme.onSurfaceVariant,
            inactiveTrackColor: colorScheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}

class TraitData {
  final IconData icon;
  final String label;
  const TraitData({required this.icon, required this.label});
}

class CandidateCard extends StatelessWidget {
  final String name;
  final String id;
  final String role;
  final int matchPercentage;
  final bool isBlind;
  final List<String> standardSkills;
  final List<String> highlightedSkills;
  final List<TraitData> traits;

  const CandidateCard({
    super.key,
    required this.name,
    required this.id,
    required this.role,
    required this.matchPercentage,
    required this.isBlind,
    required this.standardSkills,
    required this.highlightedSkills,
    required this.traits,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    // Display logic based on blind screening
    final displayName = isBlind ? 'Candidate $id' : name;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Placeholder
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isBlind ? Icons.lock_outline : Icons.person_outline,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
              ),
              const SizedBox(width: 16),
              // Candidate Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'ID: ',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          id,
                          style: TextStyle(
                            color: customColors.primaryFixedDim,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Match Percentage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$matchPercentage',
                        style: TextStyle(
                          color: customColors.primaryFixedDim,
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                          color: customColors.primaryFixedDim,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'MATCH',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Skills & Traits Wrap
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...standardSkills.map(
                (skill) => _SkillChip(label: skill, isHighlighted: false),
              ),
              ...highlightedSkills.map(
                (skill) => _SkillChip(label: skill, isHighlighted: true),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: traits.map((trait) => _TraitChip(trait: trait)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final bool isHighlighted;

  const _SkillChip({required this.label, required this.isHighlighted});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlighted
            ? customColors.primaryFixedDim.withOpacity(0.1)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted
            ? Border.all(color: customColors.primaryFixedDim.withOpacity(0.5))
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isHighlighted
              ? customColors.primaryFixedDim
              : colorScheme.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TraitChip extends StatelessWidget {
  final TraitData trait;

  const _TraitChip({required this.trait});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.surfaceContainerHigh),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trait.icon,
            size: 14,
            color: colorScheme.tertiary,
          ), // Used tertiary for purple tint
          const SizedBox(width: 6),
          Text(
            trait.label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
