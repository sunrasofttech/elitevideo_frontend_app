part of 'update_watched_count_cubit.dart';

sealed class UpdateWatchedCountState extends Equatable {}

final class UpdateWatchedCountInitial extends UpdateWatchedCountState {
  @override
  List<Object?> get props => [];
}

final class UpdateWatchedCountLoadingState extends UpdateWatchedCountState {
  @override
  List<Object?> get props => [];
}


final class UpdateWatchedCountLoadedState extends UpdateWatchedCountState {
  @override
  List<Object?> get props => [];
}

final class ServerDown extends UpdateWatchedCountState{
  @override
  List<Object?> get props => [];
  
}


final class UpdateWatchedCountErrorState extends UpdateWatchedCountState {
  final String error;
  UpdateWatchedCountErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
