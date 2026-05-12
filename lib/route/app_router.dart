import 'package:electus_app/presentation/pages/auth/login_page.dart';
import 'package:electus_app/presentation/pages/home_page.dart';
import 'package:electus_app/presentation/pages/splash_screen.dart';
import 'package:electus_app/route/auth_service.dart';
import 'package:go_router/go_router.dart';

final authService = AuthService();

class AppRouter {
  static final router = GoRouter(
    refreshListenable: authService,
    initialLocation: '/splashScreen',
    redirect: (context, state) {
      final bool isInitialized = authService.isInitialized;
      final bool isAuthenticated = authService.isAuthenticated;

      final bool isSplashPath = state.matchedLocation == '/splashScreen';
      final bool isLoginPath = state.matchedLocation == '/login';

      // 1. App is still loading (Show Splash)
      if (!isInitialized) {
        return isSplashPath ? null : '/splashScreen';
      }

      // 2. App is initialized, but user is NOT logged in
      if (!isAuthenticated) {
        if (isLoginPath) return null; // Already there, stay.
        return '/login';
      }

      // 3. User IS logged in
      // If they are on Splash or Login, move them to Home
      if (isLoginPath || isSplashPath) {
        return '/';
      }

      // No redirect needed for other pages
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/splashScreen',
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  );
}
