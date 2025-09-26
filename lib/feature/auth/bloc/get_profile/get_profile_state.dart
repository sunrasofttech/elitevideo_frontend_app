part of 'get_profile_cubit.dart';

abstract class GetProfileState extends Equatable {}

class GetProfileInitial extends GetProfileState {
  @override
  List<Object?> get props => [];
}

class GetProfileLoadingState extends GetProfileState {
  @override
  List<Object?> get props => [];
}

class GetProfileLoadedState extends GetProfileState {
  final GetUserModel model;
  GetProfileLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class ServerDown extends GetProfileState {
  @override
  List<Object?> get props => [];
}

class GetProfileErrorState extends GetProfileState {
  final String error;
  GetProfileErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
