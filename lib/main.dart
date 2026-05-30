import 'package:electus_app/core/theme/colors.dart';
import 'package:electus_app/presentation/auth/bloc/login/login_bloc.dart';
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final appRouter = AppRouter(authBloc);

    return MultiBlocProvider(
      providers: [BlocProvider<LoginBloc>(create: (context) => LoginBloc())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config,
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
      ),
    );
  }
}
