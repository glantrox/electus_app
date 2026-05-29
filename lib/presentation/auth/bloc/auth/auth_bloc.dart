import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<AuthCheckRequested>((event, emit) async {
      // Simulate splash screen / auth check
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthState(status: AuthStatus.unauthenticated));
    });

    on<AuthLoginRequested>((event, emit) {
      emit(const AuthState(status: AuthStatus.authenticated));
    });

    on<AuthLogoutRequested>((event, emit) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    });
  }
}
