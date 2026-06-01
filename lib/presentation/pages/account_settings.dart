import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../components/account/profile_avatar_section.dart';
import '../components/account/profile_details_section.dart';
import '../components/account/theme_selection_section.dart';
import '../components/account/target_culture_section.dart';

class AccountSettingsScreen extends StatefulWidget {
  final void Function(ThemeMode) themeChanged;
  final ThemeMode currentTheme;

  const AccountSettingsScreen({
    super.key,
    required this.themeChanged,
    required this.currentTheme,
  });

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  ThemeMode _themeMode = ThemeMode.light;

  // Account Show Information
  String _name = "Olan";
  String _email = "olan@email.com";
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

  @override
  void initState() {
    super.initState();
    _themeMode = widget.currentTheme;
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
  }

  void _saveProfileDetails(String name, String email, String password) {
    setState(() {
      _name = name;
      _email = email;
      _password = password;
    });
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile Saved!')));
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _handleThemeChanged(ThemeMode newTheme) {
    setState(() {
      _themeMode = newTheme;
    });
    widget.themeChanged(newTheme);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                      currentThemeMode: _themeMode,
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
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(
          color: const Color(0xFF2D7D6F),
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          )
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 40),
      child: child,
    );
  }
}