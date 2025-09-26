part of 'change_password_cubit.dart';

abstract class ChangePasswordState extends Equatable {}

class ChangePasswordInitial extends ChangePasswordState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordLoadingState extends ChangePasswordState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordLoadedState extends ChangePasswordState {
  @override
  List<Object?> get props => [];
}

class ChangePasswordErrorState extends ChangePasswordState {
  final String error;
  ChangePasswordErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
