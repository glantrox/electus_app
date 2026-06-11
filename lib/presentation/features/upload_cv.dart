import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_event.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_state.dart';

class UploadCvScreen extends StatelessWidget {
  const UploadCvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderSection(),
              SizedBox(height: 32),
              _DropzoneCard(),
              SizedBox(height: 40),
              _RecentUploadsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Candidate CVs',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Drag and drop resumes here to automatically parse and add candidates to your talent pool. Supports PDF, DOCX, and TXT files.',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _DropzoneCard extends StatelessWidget {
  const _DropzoneCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface, // The image shows a very soft gradient/shadow, surface works best for performance
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.note_add_outlined,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 32,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Drop your files here',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'or select files from your storage',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: BlocConsumer<CandidateActionBloc, CandidateActionState>(
              listener: (context, state) {
                if (state is CandidateActionSuccess) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is CandidateActionError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final isLoading = state is CandidateActionLoading;
                return ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () async {
                          FilePickerResult? result = await FilePicker.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
                          );
                          if (result != null &&
                              result.files.single.path != null) {
                            File file = File(result.files.single.path!);
                            if (context.mounted) {
                              context.read<CandidateActionBloc>().add(
                                UploadCandidateEvent(file),
                              );
                            }
                          }
                        },
                  icon: isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.folder_open),
                  label: Text(isLoading ? 'Uploading...' : 'Browse Files'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Implement camera scanner
              },
              icon: Icon(Icons.camera_alt_outlined),
              label: Text('Scan with Camera'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Maximum file size: 10MB per document.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.outlineVariant,
              fontSize: 13,
            ), // Extremely light text as per design
          ),
        ],
      ),
    );
  }
}

class _RecentUploadsSection extends StatelessWidget {
  const _RecentUploadsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.pie_chart_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Recent Uploads',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        // Hardcoded for UI mapping. In production, this maps over a list of File models.
        const _FileStatusTile(
          fileName: 'j_smith_marketing_portfolio.docx',
          fileSize: '1.1 MB',
          status: FileUploadStatus.success,
        ),
        SizedBox(height: 12),
        const _FileStatusTile(
          fileName: 'corrupted_file_001.pdf',
          errorMessage: 'Failed to parse document format.',
          status: FileUploadStatus.error,
        ),
      ],
    );
  }
}

enum FileUploadStatus { success, error, loading }

class _FileStatusTile extends StatelessWidget {
  final String fileName;
  final String? fileSize;
  final String? errorMessage;
  final FileUploadStatus status;

  const _FileStatusTile({
    required this.fileName,
    required this.status,
    this.fileSize,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isError = status == FileUploadStatus.error;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isError
            ? Theme.of(
                context,
              ).colorScheme.errorContainer.withValues(alpha: 0.5)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          // Leading Icon
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isError
                  ? Theme.of(context).colorScheme.errorContainer
                  : const Color(0xFFEAF5F2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: isError
                  ? Theme.of(context).colorScheme.error
                  : const Color(0xFF317566),
              size: 24,
            ),
          ),
          SizedBox(width: 16),

          // Middle Content (Filename & Subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                    decoration: isError
                        ? TextDecoration.lineThrough
                        : null, // Noticed this detail in your design
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  isError
                      ? (errorMessage ?? 'Upload failed')
                      : (fileSize ?? ''),
                  style: TextStyle(
                    fontSize: 13,
                    color: isError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),

          // Trailing Action
          if (isError)
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                // Retry logic
              },
            )
          else
            GestureDetector(
              onTap: () {
                // Navigate to profile
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View\nProfile',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
