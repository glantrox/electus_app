import 'package:electus_app/presentation/auth/login.dart';
import 'package:electus_app/presentation/auth/register.dart';
import 'package:electus_app/presentation/auth/splash.dart';
import 'package:electus_app/presentation/features/scan_cv.dart';
import 'package:electus_app/presentation/features/upload_cv.dart';
import 'package:electus_app/presentation/main_dashboard.dart';
import 'package:electus_app/presentation/pages/account_settings.dart';
import 'package:electus_app/presentation/pages/dashboard.dart';
import 'package:electus_app/presentation/pages/statistics.dart';
import 'package:electus_app/core/router/router_refresh_stream.dart';
import 'package:electus_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:electus_app/presentation/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Keys for nested navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _uploadNavKey = GlobalKey<NavigatorState>(debugLabel: 'upload');
final _scanNavKey = GlobalKey<NavigatorState>(debugLabel: 'scan');
final _statsNavKey = GlobalKey<NavigatorState>(debugLabel: 'stats');
final _accountNavKey = GlobalKey<NavigatorState>(debugLabel: 'account');

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter config = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final isGoingToAuthOrSplash =
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (status == AuthStatus.unknown) {
        return '/splash';
      }

      final loggedIn = status == AuthStatus.authenticated;

      // 1. Unauthenticated users trying to access protected routes
      if (!loggedIn && !isGoingToAuthOrSplash) {
        return '/login';
      }

      // 2. Unauthenticated user on splash screen should go to login
      if (!loggedIn && state.matchedLocation == '/splash') {
        return '/login';
      }

      // 3. Authenticated users trying to access login/register/splash
      if (loggedIn && isGoingToAuthOrSplash) {
        return '/home/dashboard';
      }

      return null; // No redirect needed
    },
    routes: [
      // --- Public Routes ---
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // --- Authenticated Shell (Bottom Navigation) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // This returns your main Scaffold with the BottomNavigationBar
          return MainDashboardLayout(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            routes: [
              GoRoute(
                path: '/home/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Branch 2: Upload
          StatefulShellBranch(
            navigatorKey: _uploadNavKey,
            routes: [
              GoRoute(
                path: '/upload_cv',
                builder: (context, state) => const UploadCvScreen(),
              ),
            ],
          ),

          // Branch 3: Scan
          StatefulShellBranch(
            navigatorKey: _scanNavKey,
            routes: [
              GoRoute(
                path: '/scan_cv',
                builder: (context, state) => const ScanCvScreen(),
              ),
            ],
          ),

          // Branch 4: Statistics
          StatefulShellBranch(
            navigatorKey: _statsNavKey,
            routes: [
              GoRoute(
                path: '/home/statistics',
                builder: (context, state) => const StatisticsScreen(),
              ),
            ],
          ),

          // Branch 5: Account
          StatefulShellBranch(
            navigatorKey: _accountNavKey,
            routes: [
              GoRoute(
                path: '/home/account_settings',
                builder: (context, state) => const AccountSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
