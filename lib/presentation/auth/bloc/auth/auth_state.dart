import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;

  const AuthState({this.status = AuthStatus.unknown});

  @override
  List<Object> get props => [status];
}
