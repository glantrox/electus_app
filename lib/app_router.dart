import 'package:electus_app/presentation/pages/home_page.dart';
import 'package:electus_app/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      // Semua route aplikasi akan didefinisikan di sini
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/splashScreen',
        builder: (context, state) => SplashScreen(),
      ),
    ],
  );
}
