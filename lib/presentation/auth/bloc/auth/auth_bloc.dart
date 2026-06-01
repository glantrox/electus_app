import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/usecases/auth/get_cached_token_usecase.dart';
import 'package:electus_app/domain/usecases/auth/validate_token_usecase.dart';
import 'package:electus_app/domain/usecases/auth/logout_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCachedTokenUseCase getCachedTokenUseCase;
  final ValidateTokenUseCase validateTokenUseCase;
  final LogoutUserUseCase logoutUserUseCase;

  AuthBloc({
    required this.getCachedTokenUseCase,
    required this.validateTokenUseCase,
    required this.logoutUserUseCase,
  }) : super(const AuthState()) {
    on<AuthCheckRequested>((event, emit) async {
      // Small delay for splash screen aesthetics
      await Future.delayed(const Duration(seconds: 1));
      
      final tokenResult = await getCachedTokenUseCase(NoParams());
      
      await tokenResult.fold(
        ifLeft: (failure) async => emit(const AuthState(status: AuthStatus.unauthenticated)),
        ifRight: (token) async {
          if (token != null && token.isNotEmpty) {
            // Optional: validate token remotely
            final validationResult = await validateTokenUseCase(ValidateTokenParams(token: token));
            validationResult.fold(
              ifLeft: (failure) => emit(const AuthState(status: AuthStatus.unauthenticated)),
              ifRight: (isValid) {
                if (isValid) {
                  emit(const AuthState(status: AuthStatus.authenticated));
                } else {
                  emit(const AuthState(status: AuthStatus.unauthenticated));
                }
              },
            );
          } else {
            emit(const AuthState(status: AuthStatus.unauthenticated));
          }
        },
      );
    });

    on<AuthLoginRequested>((event, emit) {
      emit(const AuthState(status: AuthStatus.authenticated));
    });

    on<AuthLogoutRequested>((event, emit) async {
      await logoutUserUseCase(NoParams());
      emit(const AuthState(status: AuthStatus.unauthenticated));
    });
  }
}

