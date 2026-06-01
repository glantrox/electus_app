import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AccountSettingsScreen extends StatefulWidget {
  final void Function(ThemeMode) ThemeChanged;
  final ThemeMode currentTheme;

  const AccountSettingsScreen({super.key, required this.ThemeChanged, required this.currentTheme});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  ThemeMode _themeMode = ThemeMode.light;
  
  // Account Show Information (Tanda)
  String _name = "Olan";
  String _email = "olan@email.com";
  String _password = '••••••••';
  File? _selectedImage;

  final Map<String, double> _defaultRiasecValues = {
    'Realistic': 0.45,
    'Investigative': 0.80,
    'Artistic': 0.65,
    'Social': 0.90,
    'Enterprising': 0.75,
    'Conventional': 0.30,
  };


  final Map<String, Color> _riasecColors = {
    'Realistic': const Color(0xFF00685C),
    'Investigative': const Color(0xFF006C49),
    'Artistic': const Color(0xFF825100),
    'Social': const Color(0xFF006B5F),
    'Enterprising': const Color(0xFF7CD6C6),
    'Conventional': const Color(0xFF6E7976),
  };

  Map<String, double> _riasecValues = {
    'Realistic': 0.45,
    'Investigative': 0.80,
    'Artistic': 0.65,
    'Social': 0.90,
    'Enterprising': 0.75,
    'Conventional': 0.30,
  };

  @override
  void initState(){
    super.initState();
    nameController.text = _name;
    emailController.text = _email;
    passwordController.text = _password;
    _themeMode = widget.currentTheme;
  }

  void resetToDefault() {
    setState(() {
      _riasecValues = Map.from(_defaultRiasecValues);
    });
  }

  Widget _buildRiasecSlider(String label, String description, ColorScheme colorScheme, Color sliderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              "${(_riasecValues[label]! * 100).toInt()}%",
              style: TextStyle(color: sliderColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
        child: Slider(
          value: _riasecValues[label]!,
          activeColor: sliderColor,
          inactiveColor: colorScheme.surfaceVariant,
          onChanged: (val) => setState(() => _riasecValues[label] = val),

        ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String? _activeField;
  String? _hoveredField;

  void _toggleField(String fieldName) {
    setState(() {
      if (_activeField == 'name') {
        _name = nameController.text;
      }
      if (_activeField == 'email') {
        _email = emailController.text;
      }
      if (_activeField == 'password'){
        _password = passwordController.text;
      }
      _activeField = _activeField == fieldName ? null : fieldName;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
      _selectedImage = File(image.path);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
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

                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border.all(
                      color: const Color(0xFF2D7D6F), 
                      width: 1.0, 
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      )
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage:
                              _selectedImage != null ? FileImage(_selectedImage!) : null,
                            child: _selectedImage == null
                            ? const Icon(Icons.person, size: 45)
                            : null
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Color(0xFF2D7D6F),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      GestureDetector(
                        onTap: _pickImage,
                        child: Text(
                          "Change Avatar",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Profile Information",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [

                            Text(
                              "Full Name",
                              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),

                            // NAME
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black26, width: 1),
                              ),
                              child: MouseRegion(
                                onEnter: (_) => setState(() => _hoveredField = 'name'),
                                onExit: (_) => setState(() => _hoveredField = null),
                                child: GestureDetector(
                                  onTap: () => _toggleField('name'),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: _activeField == 'name'
                                      ? Color(0xFF2D7D6F).withOpacity(0.08)
                                      : _hoveredField == 'name'
                                      ? Color(0xFF2D7D6F).withOpacity(0.04)
                                      : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        _activeField == 'name'
                                        ? TextField(
                                          controller: nameController,
                                          autofocus: true,
                                          style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (newValue){
                                            setState(() {
                                              _name = newValue;
                                              _activeField = null;
                                            });
                                          },
                                        )
                                        : Row(
                                          children: [
                                            Icon(Icons.person_outline, size: 22, color: colorScheme.onSurfaceVariant),
                                            SizedBox(width: 8),
                                            Text(
                                              _name,
                                              style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 16),

                            Text(
                              "Email Address",
                              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),

                            // EMAIL
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black26, width: 1),
                              ),
                              child: MouseRegion(
                                onEnter: (_) => setState(() => _hoveredField = 'email'),
                                onExit: (_) => setState(() => _hoveredField = null),
                                child: GestureDetector(
                                  onTap: () => _toggleField('email'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: _activeField == 'email'
                                      ? Color(0xFF2D7D6F).withOpacity(0.08)
                                      : _hoveredField == 'email'
                                      ? Color(0xFF2D7D6F).withOpacity(0.04)
                                      : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        _activeField == 'email'
                                        ? TextField(
                                          controller: emailController,
                                          autofocus: true,
                                          style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (newValue){
                                            setState(() {
                                              _email = newValue;
                                              _activeField = null;
                                            });
                                          },
                                        )
                                        : Row(
                                          children: [
                                            Icon(Icons.mail_outline, size: 22, color: colorScheme.onSurfaceVariant),
                                            SizedBox(width: 8),
                                            Text(
                                              _email,
                                              style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 16),
                           
                            Text(
                              "Password",
                              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 6),

                            // PASSWORD
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black26, width: 1),
                              ),
                              child: MouseRegion(
                                onEnter: (_) => setState(() => _hoveredField = 'password'),
                                onExit: (_) => setState(() => _hoveredField = null),
                                child: GestureDetector(
                                  onTap: () => _toggleField('password'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: _activeField == 'password'
                                      ? Color(0xFF2D7D6F).withOpacity(0.08)
                                      : _hoveredField == 'password'
                                      ? Color(0xFF2D7D6F).withOpacity(0.04)
                                      : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        _activeField == 'password'
                                        ? TextField(
                                          controller: passwordController,
                                          autofocus: true,
                                          obscureText: true,
                                          style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (newValue){
                                            setState(() {
                                              _password = newValue;
                                              _activeField = null;
                                            });
                                          },
                                        )
                                        : Row(
                                          children: [
                                            Icon(Icons.lock_outline, size: 22, color: colorScheme.onSurfaceVariant),
                                            SizedBox(width: 8),
                                            Text(
                                              _password,
                                              style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_activeField == 'name') _name = nameController.text;
                              if (_activeField == 'email') _email = emailController.text;
                              if (_activeField == 'password') _password = passwordController.text;
                              _activeField = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D7D6F),
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          ),
                          child: Text(
                            "Save Changes",
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Theme",
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Adjust your theme for the apps!",
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _themeMode = ThemeMode.dark);
                                  widget.ThemeChanged(ThemeMode.dark);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: _themeMode == ThemeMode.dark
                                        ? Color(0xFF2D7D6F)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Dark",
                                      style: TextStyle(
                                        color: _themeMode == ThemeMode.dark
                                            ? Colors.white
                                            : colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _themeMode = ThemeMode.light);
                                  widget.ThemeChanged(ThemeMode.light);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: _themeMode == ThemeMode.light
                                        ? Color(0xFF2D7D6F)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Light",
                                      style: TextStyle(
                                        color: _themeMode == ThemeMode.light
                                            ? Colors.white
                                            : colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Container(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.auto_graph,
                                    color: Color(0xFF00685C), size: 20),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "Target Culture",
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton.icon(
                            onPressed: resetToDefault,
                            icon: const Icon(Icons.restart_alt,
                                color: Color(0xFF00685C), size: 18),
                            label: const SizedBox(
                              width: 80,
                              child: Text(
                                "Reset to Startup Default",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF00685C), fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Adjust these sliders to define the ideal candidate fit based on the RIASEC organizational model.",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ..._riasecValues.keys.map((String key) {
                        return _buildRiasecSlider(
                          key,
                          "", 
                          colorScheme,  
                          _riasecColors[key] ?? const Color(0xFF2D7D6F),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}