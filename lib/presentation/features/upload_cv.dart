import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_event.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_state.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_event.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_event.dart';
import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:electus_app/presentation/bloc/profile/profile_event.dart';
import 'package:electus_app/domain/entities/candidate_entity.dart';
import 'package:electus_app/presentation/components/dashboard/candidate_profile_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class UploadCvScreen extends StatefulWidget {
  const UploadCvScreen({super.key});

  @override
  State<UploadCvScreen> createState() => _UploadCvScreenState();
}

class UploadedCvItem {
  final String filename;
  final String size;
  final bool isSuccess;
  final String message;
  final CandidateEntity? candidate;

  UploadedCvItem({
    required this.filename,
    required this.size,
    required this.isSuccess,
    required this.message,
    this.candidate,
  });
}

class _UploadCvScreenState extends State<UploadCvScreen> {
  final List<UploadedCvItem> _recentUploads = [];
  String? _lastSelectedFilename;
  String? _lastSelectedSize;

  Future<void> handleUploadCv() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      final filename = result.files.single.name;
      final sizeBytes = result.files.single.size;
      final sizeStr = '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';

      setState(() {
        _lastSelectedFilename = filename;
        _lastSelectedSize = sizeStr;
      });

      if (context.mounted) {
        context.read<CandidateActionBloc>().add(UploadCandidateEvent(file));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upload Candidate CVs",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Drag and drop resumes here to automatically parse and add candidates to your talent pool. Supports PDF and DOCX files.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      const Color(0xFF2D7D6F).withOpacity(0.0),
                      const Color(0xFF2D7D6F).withOpacity(0.08),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                  border: Border.all(color: const Color(0xFF2D7D6F), width: 2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2D7D6F).withOpacity(0.1),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE0F0ED),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.note_add_outlined,
                        size: 32,
                        color: Color(0xFF2D7D6F),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Drop your files here",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "or select files from your storage",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 28),
                    BlocConsumer<CandidateActionBloc, CandidateActionState>(
                      listener: (context, state) {
                        if (state is CandidateActionSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                          setState(() {
                            _recentUploads.insert(
                              0,
                              UploadedCvItem(
                                filename: _lastSelectedFilename ?? 'candidate_cv.pdf',
                                size: _lastSelectedSize ?? 'Unknown size',
                                isSuccess: true,
                                message: 'Parsed successfully',
                                candidate: state.candidate,
                              ),
                            );
                          });
                          // Trigger refreshes for Dashboard data
                          context.read<CandidateListBloc>().add(FetchCandidates());
                          context.read<AnalyticsBloc>().add(FetchAnalyticsEvent());
                          context.read<ProfileBloc>().add(FetchProfileEvent());
                        } else if (state is CandidateActionError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                          setState(() {
                            _recentUploads.insert(
                              0,
                              UploadedCvItem(
                                filename: _lastSelectedFilename ?? 'candidate_cv.pdf',
                                size: _lastSelectedSize ?? 'Unknown size',
                                isSuccess: false,
                                message: state.message,
                              ),
                            );
                          });
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is CandidateActionLoading;
                        return Column(
                          children: [
                            Center(
                              child: SizedBox(
                                width: 250,
                                height: 48,
                                child: ElevatedButton.icon(
                                  onPressed: isLoading ? null : handleUploadCv,
                                  icon: isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.folder_open_outlined,
                                          size: 18,
                                        ),
                                  label: Text(
                                    isLoading ? 'Uploading...' : 'Browse Files',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2D7D6F),
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: SizedBox(
                                width: 250,
                                height: 48,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    context.push('/scan_cv');
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 18,
                                  ),
                                  label: const Text("Scan with Camera"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF2D7D6F),
                                    side: const BorderSide(
                                      color: Color(0xFF2D7D6F),
                                    ),
                                    shape: const StadiumBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Maximum file size: 10MB per document.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              Row(
                children: const [
                  Icon(Icons.access_time, color: Color(0xFF2D7D6F), size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Recent Uploads",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_recentUploads.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      "No uploads in this session yet.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                )
              else
                ..._recentUploads.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: item.isSuccess
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              item.isSuccess ? Icons.check_circle : Icons.error,
                              color: item.isSuccess
                                  ? const Color(0xFF2D7D6F)
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.filename,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  item.isSuccess
                                      ? "Parsed successfully (${item.size})"
                                      : item.message,
                                  style: TextStyle(
                                    color: item.isSuccess ? Colors.grey : Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (item.isSuccess && item.candidate != null)
                            TextButton(
                              onPressed: () {
                                CandidateProfileBottomSheet.show(
                                  context,
                                  item.candidate!,
                                );
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "View\nProfile",
                                    style: TextStyle(
                                      color: Color(0xFF2D7D6F),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF2D7D6F),
                                    size: 16,
                                  ),
                                ],
                              ),
                            )
                          else if (!item.isSuccess)
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(item.message)),
                                );
                              },
                              icon: const Icon(Icons.info_outline, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
