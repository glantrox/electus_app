class LoginEvent {}

class OnFetchLogin extends LoginEvent {
  String email;
  String password;
  OnFetchLogin({required this.email, required this.password});
}
