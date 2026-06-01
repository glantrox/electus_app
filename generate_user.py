import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)

# Entity
user_entity = """import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String avatarUrl;
  final Map<String, double> riasecTarget;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.riasecTarget,
  });

  @override
  List<Object?> get props => [id, fullName, email, avatarUrl, riasecTarget];
}
"""

# Model
user_model = """import 'package:electus_app/domain/entities/user/user_entity.dart';

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
"""

# Repository
user_repository = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/domain/entities/user/user_entity.dart';
import 'dart:io';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateUserProfile({
    String? fullName,
    String? email,
    String? password,
    File? avatar,
  });
  Future<Either<Failure, Map<String, double>>> updateCultureFit(Map<String, double> riasecTarget);
}
"""

# DataSource
user_datasource = """import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/data/models/user/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile({
    String? fullName,
    String? email,
    String? password,
    File? avatar,
  });
  Future<Map<String, double>> updateCultureFit(Map<String, double> riasecTarget);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final String baseUrl = 'http://10.0.2.2:3000/api'; // Assuming default base URL

  UserRemoteDataSourceImpl({required this.client, required this.sharedPreferences});

  Future<String> _getToken() async {
    final token = sharedPreferences.getString('auth_token');
    if (token == null) throw ServerException(message: 'No auth token found');
    return token;
  }

  @override
  Future<UserModel> getUserProfile() async {
    final token = await _getToken();
    final response = await client.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to fetch user profile');
    }
  }

  @override
  Future<UserModel> updateUserProfile({
    String? fullName,
    String? email,
    String? password,
    File? avatar,
  }) async {
    final token = await _getToken();
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/user/profile'));
    request.headers['Authorization'] = 'Bearer $token';

    if (fullName != null) request.fields['fullName'] = fullName;
    if (email != null) request.fields['email'] = email;
    if (password != null) request.fields['password'] = password;

    if (avatar != null) {
      request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(responseData));
    } else {
      throw ServerException(message: 'Failed to update profile');
    }
  }

  @override
  Future<Map<String, double>> updateCultureFit(Map<String, double> riasecTarget) async {
    final token = await _getToken();
    final response = await client.put(
      Uri.parse('$baseUrl/user/culture-fit'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(riasecTarget),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      Map<String, double> result = {};
      decoded.forEach((key, value) {
        result[key] = (value as num).toDouble();
      });
      return result;
    } else {
      throw ServerException(message: 'Failed to update culture fit');
    }
  }
}
"""

# Repository Impl
user_repo_impl = """import 'package:dart_either/dart_either.dart';
import 'dart:io';
import 'package:electus_app/core/error/exceptions.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/data/datasources/user/user_remote_data_source.dart';
import 'package:electus_app/domain/entities/user/user_entity.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final result = await remoteDataSource.getUserProfile();
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({
    String? fullName,
    String? email,
    String? password,
    File? avatar,
  }) async {
    try {
      final result = await remoteDataSource.updateUserProfile(
        fullName: fullName,
        email: email,
        password: password,
        avatar: avatar,
      );
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> updateCultureFit(Map<String, double> riasecTarget) async {
    try {
      final result = await remoteDataSource.updateCultureFit(riasecTarget);
      return Either.right(result);
    } on ServerException catch (e) {
      return Either.left(ServerFailure(e.message));
    } catch (e) {
      return Either.left(ServerFailure('Unexpected error occurred'));
    }
  }
}
"""

# UseCases
get_profile_usecase = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/user/user_entity.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';

class GetUserProfileUseCase implements UseCase<UserEntity, NoParams> {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
"""

update_profile_usecase = """import 'package:dart_either/dart_either.dart';
import 'dart:io';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/entities/user/user_entity.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateUserProfileUseCase implements UseCase<UserEntity, UpdateUserProfileParams> {
  final UserRepository repository;

  UpdateUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
      avatar: params.avatar,
    );
  }
}

class UpdateUserProfileParams extends Equatable {
  final String? fullName;
  final String? email;
  final String? password;
  final File? avatar;

  const UpdateUserProfileParams({
    this.fullName,
    this.email,
    this.password,
    this.avatar,
  });

  @override
  List<Object?> get props => [fullName, email, password, avatar];
}
"""

update_culture_fit_usecase = """import 'package:dart_either/dart_either.dart';
import 'package:electus_app/core/error/failure.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/repositories/user/user_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateCultureFitUseCase implements UseCase<Map<String, double>, UpdateCultureFitParams> {
  final UserRepository repository;

  UpdateCultureFitUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, double>>> call(UpdateCultureFitParams params) async {
    return await repository.updateCultureFit(params.riasecTarget);
  }
}

class UpdateCultureFitParams extends Equatable {
  final Map<String, double> riasecTarget;

  const UpdateCultureFitParams(this.riasecTarget);

  @override
  List<Object> get props => [riasecTarget];
}
"""

base = "lib"
write_file(f"{base}/domain/entities/user/user_entity.dart", user_entity)
write_file(f"{base}/data/models/user/user_model.dart", user_model)
write_file(f"{base}/domain/repositories/user/user_repository.dart", user_repository)
write_file(f"{base}/data/datasources/user/user_remote_data_source.dart", user_datasource)
write_file(f"{base}/data/repositories/user/user_repository_impl.dart", user_repo_impl)
write_file(f"{base}/domain/usecases/user/get_user_profile_usecase.dart", get_profile_usecase)
write_file(f"{base}/domain/usecases/user/update_user_profile_usecase.dart", update_profile_usecase)
write_file(f"{base}/domain/usecases/user/update_culture_fit_usecase.dart", update_culture_fit_usecase)

print("Generated User Profile Data & Domain files.")
