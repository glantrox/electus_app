import 'package:electus_app/presentation/auth/login.dart';
import 'package:electus_app/presentation/auth/register.dart';
import 'package:electus_app/presentation/auth/splash.dart';
import 'package:electus_app/presentation/features/scan_cv.dart';
import 'package:electus_app/presentation/features/upload_cv.dart';
import 'package:electus_app/presentation/main_dashboard.dart';
import 'package:electus_app/presentation/pages/account_settings.dart';
import 'package:electus_app/presentation/pages/dashboard.dart';
import 'package:electus_app/presentation/pages/notification.dart';
import 'package:electus_app/presentation/pages/statistics.dart';
import 'package:electus_app/core/router/router_refresh_stream.dart';
import 'package:electus_app/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:electus_app/presentation/auth/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Keys for nested navigation
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _uploadNavKey = GlobalKey<NavigatorState>(debugLabel: 'upload');
final _statsNavKey = GlobalKey<NavigatorState>(debugLabel: 'stats');
final _accountNavKey = GlobalKey<NavigatorState>(debugLabel: 'account');

class AppRouter {
  final AuthBloc authBloc;
  final void Function(ThemeMode) onThemeChanged;

  AppRouter(
    this.authBloc, {
    required this.onThemeChanged,
  });

  late final GoRouter config = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authStatus = authBloc.state.status;
      final isGoingToAuthOrSplash =
          state.matchedLocation == '/splash' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (authStatus == AuthStatus.unknown) {
        // While checking auth, stay on splash
        if (state.matchedLocation != '/splash') {
          return '/splash';
        }
        return null;
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingToAuthOrSplash) {
          return '/home/dashboard';
        }
      } else if (authStatus == AuthStatus.unauthenticated) {
        if (!isGoingToAuthOrSplash) {
          return '/login';
        }
      }

      return null;
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
      GoRoute(
        path: '/notification',
        builder: (context, state) => NotificationScreen(),
      ),
      GoRoute(path: '/scan_cv', builder: (context, state) => ScanCvScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Add a UniqueKey to force rebuilds during hot reload
          return MainDashboardLayout(
            key:
                UniqueKey(), // Remove in production if state resets are unwanted
            navigationShell: navigationShell,
          );
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            navigatorKey: _homeNavKey,
            routes: [
              GoRoute(
                path: '/home/dashboard',
                builder: (context, state) => DashboardScreen(), // No 'const'
              ),
            ],
          ),

          // Branch 2: Upload
          StatefulShellBranch(
            navigatorKey: _uploadNavKey,
            routes: [
              GoRoute(
                path: '/upload_cv',
                builder: (context, state) => UploadCvScreen(),
              ),
            ],
          ),

          // Branch 4: Statistics
          StatefulShellBranch(
            navigatorKey: _statsNavKey,
            routes: [
              GoRoute(
                path: '/home/statistics',
                builder: (context, state) => StatisticsScreen(),
              ),
            ],
          ),

          // Branch 5: Account
          StatefulShellBranch(
            navigatorKey: _accountNavKey,
            routes: [
              GoRoute(
                path: '/home/account_settings',
                builder: (context, state) => AccountSettingsScreen(
                  themeChanged: onThemeChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}