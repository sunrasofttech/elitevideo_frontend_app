part of 'post_continue_watching_cubit.dart';

abstract class PostContinueWatchingState extends Equatable {}

class PostContinueWatchingInitial extends PostContinueWatchingState {
  @override
  List<Object?> get props => [];
}

class PostContinueWatchingLoadingState extends PostContinueWatchingState {
  @override
  List<Object?> get props => [];
}


class PostContinueWatchingLoadedState extends PostContinueWatchingState {
  @override
  List<Object?> get props => [];
}


class PostContinueWatchingErrorState extends PostContinueWatchingState {
  final String error;
  PostContinueWatchingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
