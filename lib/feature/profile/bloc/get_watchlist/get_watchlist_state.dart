part of 'get_watchlist_cubit.dart';

abstract class GetWatchlistState extends Equatable {}

class GetWatchlistInitial extends GetWatchlistState {
  @override
  List<Object?> get props => [];
}

class GetWatchlistLoadingState extends GetWatchlistState {
  @override
  List<Object?> get props => [];
}

class GetWatchlistLoadedState extends GetWatchlistState {
  final GetWatchListModel model;
  GetWatchlistLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetWatchlistErrorState extends GetWatchlistState {
  final String error;
  GetWatchlistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
