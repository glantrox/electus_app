import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Text(
          'ELECTUS',
          style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 32),
        ),
      ),
    );
  }
}
