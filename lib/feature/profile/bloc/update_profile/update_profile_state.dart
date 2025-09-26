part of 'update_profile_cubit.dart';

abstract class UpdateProfileState extends Equatable {}

class UpdateProfileInitial extends UpdateProfileState {
  @override
  List<Object?> get props => [];
}

class UpdateProfilLoadingState extends UpdateProfileState {
  @override
  List<Object?> get props => [];
}

class UpdateProfileLoadedState extends UpdateProfileState {
  @override
  List<Object?> get props => [];
}

class UpdateProfileErrorState extends UpdateProfileState {
  final String error;
  UpdateProfileErrorState(this.error);
  @override
  List<Object?> get props => [error];
}