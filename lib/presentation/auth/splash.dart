import 'package:electus_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Text(
          'ELECTUS',
          style: TextStyle(color: AppColor.surface, fontSize: 32),
        ),
      ),
    );
  }
}
