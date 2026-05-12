import 'package:electus_app/route/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Electus App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: AppRouter.router,
    );
  }
}
