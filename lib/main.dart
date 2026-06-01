import 'package:electus_app/router.dart';
import 'package:electus_app/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:electus_app/presentation/auth/bloc/auth/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => AuthBloc()..add(AuthCheckRequested()),
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

  void toggleTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final appRouter = AppRouter(
      authBloc,
      onThemeChanged: toggleTheme,
      themeMode: _themeMode,
    );

    return MultiBlocProvider(
      providers: [BlocProvider<AuthBloc>(create: (context) => AuthBloc())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config,
        themeMode: _themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            surface: Color(0xFFF0F4F3),
            surfaceVariant: Colors.white,
            onSurface: Color(0xFF1A2E2A),
            onSurfaceVariant: Color(0xFF6B7280),
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(
            surface: Color(0xFF1E1E1E),
            surfaceVariant: Color(0xFF2C2C2C),
            onSurface: Colors.white,
            onSurfaceVariant: Colors.grey,
          ),
          scaffoldBackgroundColor: Colors.black,
        ),
      ),
    );
  }
}