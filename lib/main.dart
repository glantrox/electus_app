import 'package:electus_app/domain/entities/stage.dart';
import 'package:electus_app/route/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  // Development Stage
  // Jadi ada 3 tipe production stage, ubah sesuai kebutuhan kalian, dalam ini
  // developmentUI, production, developmentRegular
  // kalian ubah variabel appStage di bawah ini, misalnya kalau kalian lagi
  // develop UI nya dan kalian lagi testing, kalian ubah appStage ini menjadi
  // 'AppStage.developmentUI'
  // Development UI: Kalo kalian lagi develop dan testing UI, dalam konteks ini middleware redirect tidak akan terlibat
  // Development Regular: Jika kalian lagi develop aplikasi biasa dengan intervensi middleware
  static AppStage appStage = AppStage.developmentRegular;
  final GoRouter appRouter = AppRouter(appStage).router;
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Electus App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: appRouter,
    );
  }
}
