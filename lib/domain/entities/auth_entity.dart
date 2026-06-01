import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String token;
  final Map<String, dynamic> user;

  const AuthEntity({
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [token, user];
}
