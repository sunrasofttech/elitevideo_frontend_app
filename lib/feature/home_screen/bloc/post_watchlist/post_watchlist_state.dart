part of 'post_watchlist_cubit.dart';

abstract class PostWatchlistState extends Equatable {}

class PostWatchlistInitial extends PostWatchlistState {
  @override
  List<Object?> get props => [];
}

class PostWatchlistLoadingState extends PostWatchlistState {
  @override
  List<Object?> get props => [];
}


class PostWatchlistLoadedState extends PostWatchlistState {
  @override
  List<Object?> get props => [];
}


class PostWatchlistErrorState extends PostWatchlistState {
  final String error;
  PostWatchlistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
