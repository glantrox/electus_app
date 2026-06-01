import 'package:flutter_bloc/flutter_bloc.dart';
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
