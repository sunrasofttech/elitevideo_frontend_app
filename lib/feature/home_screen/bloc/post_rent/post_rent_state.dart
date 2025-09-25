part of 'post_rent_cubit.dart';

abstract class PostRentState extends Equatable {}

class PostRentInitial extends PostRentState {
  @override
  List<Object?> get props => [];
}

class PostRentLoadingState extends PostRentState {
  @override
  List<Object?> get props => [];
}

class PostRentLoadedState extends PostRentState {
  @override
  List<Object?> get props => [];
}

class PostRentErrorState extends PostRentState {
  final String error;
  PostRentErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
