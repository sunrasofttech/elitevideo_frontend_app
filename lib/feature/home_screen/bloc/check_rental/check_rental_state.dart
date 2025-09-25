part of 'check_rental_cubit.dart';

sealed class CheckRentalState extends Equatable {}

final class CheckRentalInitial extends CheckRentalState {
  @override
  List<Object?> get props => [];
}


final class CheckRentalLoadingState extends CheckRentalState {
  @override
  List<Object?> get props => [];
}

final class CheckRentalLoadedState extends CheckRentalState {
  final CheckRentalModel model;
  CheckRentalLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class CheckRentalErrorState extends CheckRentalState {
  final String error;
  CheckRentalErrorState(this.error);
  @override
  List<Object?> get props => [error];
}