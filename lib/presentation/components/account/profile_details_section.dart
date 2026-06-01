import 'package:flutter/material.dart';

class ProfileDetailsSection extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPassword;
  final void Function(String name, String email, String password) onSave;

  const ProfileDetailsSection({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPassword,
    required this.onSave,
  });

  @override
  State<ProfileDetailsSection> createState() => _ProfileDetailsSectionState();
}

class _ProfileDetailsSectionState extends State<ProfileDetailsSection> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String _name = '';
  String _email = '';
  String _password = '';

  String? _activeField;
  String? _hoveredField;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    _email = widget.initialEmail;
    _password = widget.initialPassword;

    _nameController = TextEditingController(text: _name);
    _emailController = TextEditingController(text: _email);
    _passwordController = TextEditingController(text: _password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleField(String fieldName) {
    setState(() {
      if (_activeField == 'name') _name = _nameController.text;
      if (_activeField == 'email') _email = _emailController.text;
      if (_activeField == 'password') _password = _passwordController.text;
      _activeField = _activeField == fieldName ? null : fieldName;
    });
  }

  Widget _buildEditableField({
    required String label,
    required String fieldName,
    required IconData icon,
    required String currentValue,
    required TextEditingController controller,
    required ColorScheme colorScheme,
    bool isPassword = false,
  }) {
    final isActive = _activeField == fieldName;
    final isHovered = _hoveredField == fieldName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26, width: 1),
          ),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hoveredField = fieldName),
            onExit: (_) => setState(() => _hoveredField = null),
            child: GestureDetector(
              onTap: () => _toggleField(fieldName),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF2D7D6F).withValues(alpha: 0.08)
                      : isHovered
                          ? const Color(0xFF2D7D6F).withValues(alpha: 0.04)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    isActive
                        ? TextField(
                            controller: controller,
                            autofocus: true,
                            obscureText: isPassword,
                            style: TextStyle(
                                color: colorScheme.onSurface, fontSize: 14),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                            onSubmitted: (newValue) {
                              setState(() {
                                if (fieldName == 'name') _name = newValue;
                                if (fieldName == 'email') _email = newValue;
                                if (fieldName == 'password') _password = newValue;
                                _activeField = null;
                              });
                            },
                          )
                        : Row(
                            children: [
                              Icon(icon,
                                  size: 22,
                                  color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 8),
                              Text(
                                currentValue,
                                style: TextStyle(
                                    color: colorScheme.onSurface, fontSize: 14),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        const SizedBox(height: 16),
        _buildEditableField(
          label: "Full Name",
          fieldName: 'name',
          icon: Icons.person_outline,
          currentValue: _name,
          controller: _nameController,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildEditableField(
          label: "Email Address",
          fieldName: 'email',
          icon: Icons.mail_outline,
          currentValue: _email,
          controller: _emailController,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildEditableField(
          label: "Password",
          fieldName: 'password',
          icon: Icons.lock_outline,
          currentValue: _password,
          controller: _passwordController,
          colorScheme: colorScheme,
          isPassword: true,
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_activeField == 'name') _name = _nameController.text;
                if (_activeField == 'email') _email = _emailController.text;
                if (_activeField == 'password') {
                  _password = _passwordController.text;
                }
                _activeField = null;
              });
              widget.onSave(_name, _email, _password);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D7D6F),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
