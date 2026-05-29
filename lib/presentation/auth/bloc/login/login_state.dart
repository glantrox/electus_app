// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class InitLS extends LoginState {}

class LoadingLS extends LoginState {}

class ErrorLS extends LoginState {
  final String message;
  const ErrorLS({required this.message});
}
