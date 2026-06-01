import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class UploadCvScreen extends StatelessWidget {
  const UploadCvScreen({super.key});

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
        const Text(
          'Upload Candidate CVs',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColor.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Drag and drop resumes here to automatically parse and add candidates to your talent pool. Supports PDF, DOCX, and TXT files.',
          style: TextStyle(
            fontSize: 16,
            color: AppColor.textSecondary,
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
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColor
            .surface, // The image shows a very soft gradient/shadow, surface works best for performance
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.borderLight.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withValues(alpha: 0.05),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.iconTealBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.note_add_outlined,
              color: AppColor.iconTeal,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Drop your files here',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'or select files from your storage',
            style: TextStyle(color: AppColor.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Implement file picker
              },
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse Files'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.textInverse,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Implement camera scanner
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Scan with Camera'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.primary,
                side: const BorderSide(color: AppColor.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Maximum file size: 10MB per document.',
            style: TextStyle(
              color: AppColor.borderLight,
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
          children: const [
            Icon(Icons.pie_chart_outline, color: AppColor.primary, size: 24),
            SizedBox(width: 8),
            Text(
              'Recent Uploads',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Hardcoded for UI mapping. In production, this maps over a list of File models.
        const _FileStatusTile(
          fileName: 'j_smith_marketing_portfolio.docx',
          fileSize: '1.1 MB',
          status: FileUploadStatus.success,
        ),
        const SizedBox(height: 12),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isError
            ? AppColor.errorBackground.withValues(alpha: 0.5)
            : AppColor.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError ? AppColor.errorBackground : AppColor.borderLight,
        ),
      ),
      child: Row(
        children: [
          // Leading Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isError
                  ? AppColor.errorBackground
                  : AppColor.successBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: isError ? AppColor.errorIcon : AppColor.successText,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Middle Content (Filename & Subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                    decoration: isError
                        ? TextDecoration.lineThrough
                        : null, // Noticed this detail in your design
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  isError
                      ? (errorMessage ?? 'Upload failed')
                      : (fileSize ?? ''),
                  style: TextStyle(
                    fontSize: 13,
                    color: isError
                        ? AppColor.errorText
                        : AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Trailing Action
          if (isError)
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColor.textSecondary),
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
                children: const [
                  Text(
                    'View\nProfile',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: AppColor.primary, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
