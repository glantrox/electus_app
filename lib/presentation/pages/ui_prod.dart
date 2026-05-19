import 'package:electus_app/presentation/pages/candidate_page.dart';
import 'package:electus_app/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';

class UiProdPage extends StatefulWidget {
  const UiProdPage({super.key});

  @override
  State<UiProdPage> createState() => _UiProdPageState();
}

class _UiProdPageState extends State<UiProdPage> {
  // Jika kalian udah selesai testing / develop UI:
  // 1. Kalian tinggal copy paste function 'build()' nya aj
  // 2. Buat file baru di folder page akhiri nama file dengan '{nama}_page', sesuaikan struktur modul nya juga.
  // 3. Definisikan route nya di 'route/app_router.dart' di dalam object router dan tambahin
  //    GoRouter('/{routeName}') ikutin aja formatnya kayak route yang lain, dan sesuaikan.
  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
