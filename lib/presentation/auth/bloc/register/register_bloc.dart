import 'package:electus_app/presentation/auth/bloc/register/register_event.dart';
import 'package:electus_app/presentation/auth/bloc/register/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<OnFetchRegister>((event, emit) async {});
  }
}
