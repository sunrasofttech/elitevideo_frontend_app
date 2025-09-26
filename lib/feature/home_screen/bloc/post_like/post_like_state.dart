part of 'post_like_cubit.dart';

abstract class PostLikeState extends Equatable {}

class PostLikeInitial extends PostLikeState {
  @override
  List<Object?> get props => [];
}

class PostLikeLoadingState extends PostLikeState {
  @override
  List<Object?> get props => [];
}

class PostLikeLoadedState extends PostLikeState {
  @override
  List<Object?> get props => [];
}

class PostLikeErrorState extends PostLikeState {
  final String error;
  PostLikeErrorState(this.error);
  @override
  List<Object?> get props => [error];
}