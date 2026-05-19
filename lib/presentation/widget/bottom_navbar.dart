// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:electus_app/presentation/widget/style/colors.dart';

class AppBottomNavbar extends StatelessWidget {
  // 1. Mark fields final to maintain immutability
  final int selectedIndex;
  // 2. Use ValueChanged<int> for correct callback typing
  final ValueChanged<int> onItemTapped;

  const AppBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  // 3. Define items as static const to prevent re-allocation on every build pass
  static const List<BottomNavigationBarItem> _listOfNavbarItem = [
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
      // 4. Correctly wire the required parameters
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType
          .fixed, // Prevents shifting behavior if items > 3
      selectedItemColor: AppColors.onPrimaryContainer,
      unselectedItemColor: AppColors.onSurfaceVariant,
      items: _listOfNavbarItem,
    );
  }
}
