import 'package:equatable/equatable.dart';
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
