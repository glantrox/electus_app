import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatarSection extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onPickImage;

  const ProfileAvatarSection({
    super.key,
    required this.selectedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage:
                  selectedImage != null ? FileImage(selectedImage!) : null,
              child: selectedImage == null
                  ? const Icon(Icons.person, size: 45)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onPickImage,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D7D6F),
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
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickImage,
          child: Text(
            "Change Avatar",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
