import os

def write_file(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)

# PROFILE BLOC
profile_event = """import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String? fullName;
  final String? email;
  final String? password;
  final File? avatar;

  const UpdateProfileEvent({this.fullName, this.email, this.password, this.avatar});

  @override
  List<Object?> get props => [fullName, email, password, avatar];
}

class UpdateCultureFitEvent extends ProfileEvent {
  final Map<String, double> riasecTarget;

  const UpdateCultureFitEvent(this.riasecTarget);

  @override
  List<Object> get props => [riasecTarget];
}
"""

profile_state = """import 'package:equatable/equatable.dart';
import 'package:electus_app/domain/entities/user/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileActionSuccess extends ProfileState {
  final String message;
  final UserEntity? user;
  
  const ProfileActionSuccess(this.message, {this.user});

  @override
  List<Object?> get props => [message, user];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
"""

profile_bloc = """import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:electus_app/core/usecases/usecase.dart';
import 'package:electus_app/domain/usecases/user/get_user_profile_usecase.dart';
import 'package:electus_app/domain/usecases/user/update_user_profile_usecase.dart';
import 'package:electus_app/domain/usecases/user/update_culture_fit_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfileUseCase getProfile;
  final UpdateUserProfileUseCase updateProfile;
  final UpdateCultureFitUseCase updateCultureFit;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.updateCultureFit,
  }) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UpdateCultureFitEvent>(_onUpdateCultureFit);
  }

  Future<void> _onFetchProfile(FetchProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await getProfile(NoParams());
    result.fold(
      ifLeft: (failure) => emit(ProfileError(failure.message)),
      ifRight: (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await updateProfile(UpdateUserProfileParams(
      fullName: event.fullName,
      email: event.email,
      password: event.password,
      avatar: event.avatar,
    ));
    result.fold(
      ifLeft: (failure) => emit(ProfileError(failure.message)),
      ifRight: (user) {
        emit(ProfileActionSuccess('Profile updated successfully', user: user));
        emit(ProfileLoaded(user));
      }
    );
  }

  Future<void> _onUpdateCultureFit(UpdateCultureFitEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await updateCultureFit(UpdateCultureFitParams(event.riasecTarget));
    result.fold(
      ifLeft: (failure) => emit(ProfileError(failure.message)),
      ifRight: (_) {
        emit(const ProfileActionSuccess('Target culture updated successfully'));
        add(FetchProfileEvent());
      }
    );
  }
}
"""

base = "lib"
write_file(f"{base}/presentation/bloc/profile/profile_event.dart", profile_event)
write_file(f"{base}/presentation/bloc/profile/profile_state.dart", profile_state)
write_file(f"{base}/presentation/bloc/profile/profile_bloc.dart", profile_bloc)

print("Generated Profile BLoC")
