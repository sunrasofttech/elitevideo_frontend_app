part of 'forget_password_cubit.dart';

abstract class ForgetPasswordState extends Equatable {}

class ForgetPasswordInitial extends ForgetPasswordState {
  @override
  List<Object?> get props => [];
}

class ForgetPasswordLoadingState extends ForgetPasswordState {
  @override
  List<Object?> get props => [];
}

class ForgetPasswordLoadedState extends ForgetPasswordState {
  @override
  List<Object?> get props => [];
}

class ForgetPasswordErrorState extends ForgetPasswordState {
  final String error;
  ForgetPasswordErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
