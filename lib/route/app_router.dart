import 'package:electus_app/presentation/pages/auth/login_page.dart';
import 'package:electus_app/presentation/pages/home_page.dart';
import 'package:electus_app/presentation/pages/splash_screen.dart';
import 'package:electus_app/route/auth_service.dart';
import 'package:go_router/go_router.dart';

final authService = AuthService();

class AppRouter {
  static final router = GoRouter(
    refreshListenable: authService,
    initialLocation: '/',
    redirect: (context, state) {
      final bool loggingIn = state.matchedLocation == '/login';
      if (!authService.isAuthenticated) return '/login';
      if (loggingIn) return '/';
      return null;
    },
    routes: [
      // Semua route aplikasi akan didefinisikan di sini
      // Home Page
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      // Splash Screen
      GoRoute(
        path: '/splashScreen',
        builder: (context, state) => SplashScreen(),
      ),
    ],
  );
}
