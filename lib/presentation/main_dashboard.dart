import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainDashboardLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainDashboardLayout({Key? key, required this.navigationShell})
    : super(key: key);

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern: tapping an active tab pops it back to its root
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
