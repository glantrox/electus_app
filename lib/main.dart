import 'package:electus_app/core/theme/colors.dart';
import 'package:electus_app/presentation/auth/bloc/login/login_bloc.dart';
import 'package:electus_app/router.dart';
import 'package:electus_app/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:electus_app/presentation/auth/bloc/auth/auth_event.dart';
import 'package:electus_app/presentation/auth/bloc/register/register_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_list/candidate_list_bloc.dart';
import 'package:electus_app/presentation/bloc/candidate_action/candidate_action_bloc.dart';

import 'package:electus_app/presentation/bloc/profile/profile_bloc.dart';
import 'package:electus_app/presentation/bloc/profile/profile_event.dart';
import 'package:electus_app/presentation/bloc/notification/notification_bloc.dart';
import 'package:electus_app/presentation/bloc/notification/notification_event.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_bloc.dart';
import 'package:electus_app/presentation/bloc/analytics/analytics_event.dart';
import 'package:electus_app/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await dependencyInjection();
  runApp(
    BlocProvider(
      create: (_) => di<AuthBloc>()..add(AuthCheckRequested()),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.light;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      context.read<AuthBloc>(),
      onThemeChanged: toggleTheme,
    );
  }

  void toggleTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => di<LoginBloc>()),
        BlocProvider<RegisterBloc>(create: (context) => di<RegisterBloc>()),
        BlocProvider<CandidateListBloc>(
          create: (context) => di<CandidateListBloc>(),
        ),

        BlocProvider<CandidateActionBloc>(
          create: (context) => di<CandidateActionBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => di<ProfileBloc>()..add(FetchProfileEvent()),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) =>
              di<NotificationBloc>()..add(FetchNotificationsEvent()),
        ),
        BlocProvider<AnalyticsBloc>(
          create: (context) => di<AnalyticsBloc>()..add(FetchAnalyticsEvent()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config,
        themeMode: _themeMode,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: AppColor.primary,
          scaffoldBackgroundColor: AppColor.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.primary,
            primary: AppColor.primary,
            onPrimary: AppColor.textInverse,
            surface: AppColor.surface,
            onSurface: AppColor.textPrimary,
            error: AppColor.errorText,
            onError: AppColor.textInverse,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColor.textPrimary),
            bodyMedium: TextStyle(color: AppColor.textPrimary),
            bodySmall: TextStyle(color: AppColor.textSecondary),
            titleLarge: TextStyle(
              color: AppColor.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.surface,
            foregroundColor: AppColor.textPrimary,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColor.textPrimary),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: AppColor.surface,
            filled: true,
            hintStyle: const TextStyle(color: AppColor.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: AppColor.primary,
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: AppColor.primary,
            primary: AppColor.primary,
            onPrimary: AppColor.textInverse,
            surface: const Color(0xFF1E1E1E),
            onSurface: Colors.white,
            error: AppColor.errorText,
            onError: AppColor.textInverse,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            bodySmall: TextStyle(color: Colors.white60),
            titleLarge: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.textInverse,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: const Color(0xFF2C2C2C),
            filled: true,
            hintStyle: const TextStyle(color: Colors.white60),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
