class RegisterEvent {}

class OnFetchRegister extends RegisterEvent {
  String email;
  String password;
  OnFetchRegister({required this.email, required this.password});
}
