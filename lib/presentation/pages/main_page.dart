import 'package:electus_app/presentation/pages/section/account_section.dart';
import 'package:electus_app/presentation/pages/section/home_section.dart';
import 'package:electus_app/presentation/pages/section/scan_section.dart';
import 'package:electus_app/presentation/pages/section/statistic_section.dart';
import 'package:electus_app/presentation/pages/section/upload_section.dart';
import 'package:electus_app/presentation/widget/bottom_navbar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomNavbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeSection(),
          StatisticSection(),
          ScanSection(),
          UploadSection(),
          AccountSection(),
        ],
      ),
    );
  }
}
