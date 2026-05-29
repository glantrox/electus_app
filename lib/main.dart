import 'package:electus_app/router.dart';
import 'package:electus_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:electus_app/presentation/auth/bloc/auth_event.dart';
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

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config,
    );
  }
}
