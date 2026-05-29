import 'package:electus_app/presentation/auth/bloc/login/login_event.dart';
import 'package:electus_app/presentation/auth/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<OnFetchLogin>((event, emit) async {
      emit(LoadingLS());
      Future.delayed(const Duration(seconds: 2));
      emit(SuccessLS());
    });
  }
}
