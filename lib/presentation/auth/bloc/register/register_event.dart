class RegisterEvent {}

class OnFetchRegister extends RegisterEvent {
  final String fullName;
  final String email;
  final String password;
  OnFetchRegister({required this.fullName, required this.email, required this.password});
}
