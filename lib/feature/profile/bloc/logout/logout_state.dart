part of 'logout_cubit.dart';

abstract class LogoutState extends Equatable {}

class LogoutInitial extends LogoutState {
  @override
  List<Object?> get props => [];
}

class LogoutLoadingState extends LogoutState {
  @override
  List<Object?> get props => [];
}


class LogoutLoadedState extends LogoutState {
  @override
  List<Object?> get props => [];
}

class LogoutErrorState extends LogoutState {
  final String error;
  LogoutErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
