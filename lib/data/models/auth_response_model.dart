import 'package:electus_app/domain/entities/auth_entity.dart';

class AuthResponseModel {
  final String token;
  final Map<String, dynamic> user;

  AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] ?? json['accessToken'] ?? '',
      user: json['user'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user};
  }

  AuthEntity toEntity() {
    return AuthEntity(token: token, user: user);
  }
}
