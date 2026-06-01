import 'package:electus_app/presentation/auth/bloc/login/login_event.dart';
import 'package:electus_app/presentation/auth/bloc/login/login_state.dart';
import 'package:electus_app/domain/usecases/auth/login_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUserUseCase loginUserUseCase;

  LoginBloc({required this.loginUserUseCase}) : super(const LoginState()) {
    on<OnFetchLogin>((event, emit) async {
      emit(LoadingLS());
      
      final result = await loginUserUseCase(
        LoginUserParams(email: event.email, password: event.password),
      );

      result.fold(
        ifLeft: (failure) => emit(ErrorLS(message: failure.message)),
        ifRight: (user) => emit(SuccessLS()),
      );
    });
  }
}
