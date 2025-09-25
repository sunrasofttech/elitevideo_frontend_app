part of 'post_resent_serch_cubit.dart';

sealed class PostResentSerchState extends Equatable {}

final class PostResentSerchInitial extends PostResentSerchState {
  @override
  List<Object?> get props => [];
}

final class PostResentSerchLoadingState extends PostResentSerchState {
  @override
  List<Object?> get props => [];
}

final class PostResentSerchLoadedState extends PostResentSerchState {
  @override
  List<Object?> get props => [];
}

final class PostResentSerchErrorState extends PostResentSerchState {
  final String error;
  PostResentSerchErrorState(this.error);
  @override
  List<Object?> get props => [];
}