import 'package:electus_app/presentation/auth/bloc/register/register_event.dart';
import 'package:electus_app/presentation/auth/bloc/register/register_state.dart';
import 'package:electus_app/domain/usecases/auth/register_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUserUseCase registerUserUseCase;

  RegisterBloc({required this.registerUserUseCase}) : super(const RegisterState()) {
    on<OnFetchRegister>((event, emit) async {
      emit(LoadingRS());

      final result = await registerUserUseCase(
        RegisterUserParams(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
        ),
      );

      result.fold(
        ifLeft: (failure) => emit(ErrorRS(message: failure.message)),
        ifRight: (user) => emit(SuccessRS()),
      );
    });
  }
}
