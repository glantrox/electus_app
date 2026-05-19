import 'package:electus_app/presentation/widget/style/colors.dart';
import 'package:flutter/material.dart';

class AppBottomNavbar extends StatefulWidget {
  const AppBottomNavbar({super.key});

  @override
  State<AppBottomNavbar> createState() => _AppBottomNavbarState();
}

class _AppBottomNavbarState extends State<AppBottomNavbar> {
  List<BottomNavigationBarItem> listOfNavbarItem = [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_rounded),
      label: 'Statistics',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.camera_alt_rounded),
      label: 'Scan',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Upload'),
    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Account'),
  ];
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: AppColors.onPrimaryContainer,
      unselectedItemColor: AppColors.onSurfaceVariant,
      items: listOfNavbarItem,
    );
  }
}
