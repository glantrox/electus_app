import 'package:electus_app/domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.avatarUrl,
    required super.riasecTarget,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    Map<String, double> riasec = {};
    if (json['riasecTarget'] != null) {
      final riasecMap = json['riasecTarget'] as Map<String, dynamic>;
      riasecMap.forEach((key, value) {
        riasec[key] = (value as num).toDouble();
      });
    }

    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      riasecTarget: riasec,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'avatarUrl': avatarUrl,
      'riasecTarget': riasecTarget,
    };
  }
}
