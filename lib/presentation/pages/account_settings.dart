import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:electus_app/presentation/bloc/profile/profile_event.dart';
import 'package:electus_app/presentation/bloc/profile/profile_state.dart';
import '../components/account/profile_avatar_section.dart';
import '../components/account/profile_details_section.dart';
import '../components/account/theme_selection_section.dart';
import '../components/account/target_culture_section.dart';
import 'package:electus_app/presentation/components/common/skeleton/shimmer_skeleton.dart';
import 'package:electus_app/presentation/components/common/skeleton/skeleton_card.dart';

class AccountSettingsScreen extends StatefulWidget {
  final void Function(ThemeMode) themeChanged;

  const AccountSettingsScreen({super.key, required this.themeChanged});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // Local state initialized from BLoC
  String _name = "";
  String _email = "";
  String _password = '••••••••';
  File? _selectedImage;

  static const Map<String, double> _defaultRiasecValues = {
    'Realistic': 0.45,
    'Investigative': 0.80,
    'Artistic': 0.65,
    'Social': 0.90,
    'Enterprising': 0.75,
    'Conventional': 0.30,
  };

  Map<String, double> _riasecValues = Map.from(_defaultRiasecValues);
  bool _isInitialized = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  void _initializeFromState(ProfileLoaded state) {
    if (!_isInitialized) {
      _name = state.user.fullName;
      _email = state.user.email;
      if (state.user.riasecTarget.isNotEmpty) {
        _riasecValues = Map.from(state.user.riasecTarget);
      }
      _isInitialized = true;
    }
  }

  void _resetRiasecToDefault() {
    setState(() {
      _riasecValues = Map.from(_defaultRiasecValues);
    });
  }

  void _updateRiasecValue(String label, double value) {
    setState(() {
      _riasecValues[label] = value;
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ProfileBloc>().add(UpdateCultureFitEvent(_riasecValues));
    });
  }

  void _saveProfileDetails(String name, String email, String password) {
    setState(() {
      _name = name;
      _email = email;
      _password = password;
    });

    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        fullName: name,
        email: email,
        password: password != '••••••••' ? password : null,
        avatar: _selectedImage,
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      // Optionally save immediately
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(avatar: _selectedImage),
      );
    }
  }

  void _handleThemeChanged(ThemeMode newTheme) {
    widget.themeChanged(newTheme);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileActionSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading && !_isInitialized) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SkeletonBox(width: 150, height: 32),
                      const SizedBox(height: 4),
                      const SkeletonBox(width: 250, height: 16),
                      const SizedBox(height: 24),
                      _buildCardContainer(
                        child: ShimmerSkeleton(
                          child: Column(
                            children: [
                              const SkeletonBox(
                                width: 100,
                                height: 100,
                                borderRadius: 50,
                              ),
                              const SizedBox(height: 40),
                              const SkeletonBox(
                                width: double.infinity,
                                height: 56,
                              ),
                              const SizedBox(height: 16),
                              const SkeletonBox(
                                width: double.infinity,
                                height: 56,
                              ),
                              const SizedBox(height: 16),
                              const SkeletonBox(
                                width: double.infinity,
                                height: 56,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is ProfileLoaded) {
              _initializeFromState(state);
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Manage your profile and target culture settings",
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Profile Section Container
                    _buildCardContainer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ProfileAvatarSection(
                            selectedImage: _selectedImage,
                            onPickImage: _pickImage,
                            // Optional: pass avatarUrl to load remote image if _selectedImage is null
                          ),
                          const SizedBox(height: 20),
                          ProfileDetailsSection(
                            initialName: _name,
                            initialEmail: _email,
                            initialPassword: _password,
                            onSave: _saveProfileDetails,
                          ),
                          const SizedBox(height: 24),
                          ThemeSelectionSection(
                            currentThemeMode:
                                Theme.of(context).brightness == Brightness.dark
                                ? ThemeMode.dark
                                : ThemeMode.light,
                            onThemeChanged: _handleThemeChanged,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Target Culture Section Container
                    _buildCardContainer(
                      child: TargetCultureSection(
                        riasecValues: _riasecValues,
                        onReset: _resetRiasecToDefault,
                        onChanged: _updateRiasecValue,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: const Color(0xFF2D7D6F), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 40),
      child: child,
    );
  }
}
