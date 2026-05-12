import 'package:electus_app/domain/entities/stage.dart';
import 'package:electus_app/presentation/pages/auth/login_page.dart';
import 'package:electus_app/presentation/pages/home_page.dart';
import 'package:electus_app/presentation/pages/splash_screen.dart';
import 'package:electus_app/presentation/pages/ui_prod.dart';
import 'package:electus_app/route/auth_service.dart';
import 'package:go_router/go_router.dart';

final authService = AuthService();

class AppRouter {
  AppStage _stage;
  AppRouter(AppStage stage) : _stage = stage;

  GoRouter get router => GoRouter(
    refreshListenable: authService,
    initialLocation: '/splashScreen',
    redirect: (context, state) {
      final bool isInitialized = authService.isInitialized;
      final bool isAuthenticated = authService.isAuthenticated;

      final bool isSplashPath = state.matchedLocation == '/splashScreen';
      final bool isLoginPath = state.matchedLocation == '/login';
      if (_stage == AppStage.developmentUI) return '/uiProd';
      if (!isInitialized) return isSplashPath ? null : '/splashScreen';

      if (!isAuthenticated) {
        if (isLoginPath) return null; // Already there stay.
        return '/login';
      }

      if (isLoginPath || isSplashPath) return '/';

      return null;
    },

    routes: [
      // List semua routernya
      GoRoute(path: '/uiProd', builder: (context, state) => const UiProdPage()),
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/splashScreen',
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  );
}
