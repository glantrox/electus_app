import 'package:flutter/material.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';

class CandidateProfileBottomSheet extends StatelessWidget {
  final CandidateEntity candidate;

  const CandidateProfileBottomSheet({super.key, required this.candidate});

  static void show(BuildContext context, CandidateEntity candidate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => CandidateProfileBottomSheet(candidate: candidate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final name = candidate.fullName.isNotEmpty ? candidate.fullName : 'Anonymous Candidate';
    final subtitle = [
      if (candidate.education.isNotEmpty) candidate.education,
      if (candidate.experience.isNotEmpty) candidate.experience,
    ].join(' · ');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFFDCEBFF),
                    child: Icon(Icons.person_outline, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: colorScheme.onSurfaceVariant,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(color: colorScheme.outlineVariant, height: 1),
            
            // AI Summary Section
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'AI Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (candidate.aiSummary.isNotEmpty)
                      ...candidate.aiSummary.map((point) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6, right: 12),
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: colorScheme.primary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: colorScheme.onSurfaceVariant,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))
                    else
                      Text(
                        'No summary available.',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            Divider(color: colorScheme.outlineVariant, height: 1),
            
            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement email sending functionality
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.mail_outline, size: 20),
                    label: const Text(
                      'Send Interview Invite via Email',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Implement Mark Done functionality
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Done Reviewing',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
