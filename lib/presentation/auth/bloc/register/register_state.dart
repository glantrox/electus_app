// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class InitRS extends RegisterState {}

class LoadingRS extends RegisterState {}

class ErrorRS extends RegisterState {
  final String message;
  const ErrorRS({required this.message});
}
