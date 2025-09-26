part of 'login_cubit.dart';

abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoadedState extends LoginState {
  final LoginModel model;
  LoginLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class LoginErrorState extends LoginState {
  final LoginErrorModel? model;
  final String error;
  LoginErrorState({this.model,required this.error});
  @override
  List<Object?> get props => [error];
}
