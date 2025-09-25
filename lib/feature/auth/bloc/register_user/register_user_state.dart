part of 'register_user_cubit.dart';

abstract class RegisterUserState extends Equatable {}

class RegisterUserInitial extends RegisterUserState {
  @override
  List<Object?> get props => [];
}

class RegisterUserLoadingState extends RegisterUserState {
  @override
  List<Object?> get props => [];
}

class RegisterUserLoadedState extends RegisterUserState {
  @override
  List<Object?> get props => [];
}

class RegisterUserErrorState extends RegisterUserState {
  final String error;
  RegisterUserErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
