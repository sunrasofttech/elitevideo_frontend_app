part of 'get_continue_watching_cubit.dart';

abstract class GetContinueWatchingState extends Equatable {}

class GetContinueWatchingInitial extends GetContinueWatchingState {
  @override
  List<Object?> get props => [];
}

class GetContinueWatchingLoadingState extends GetContinueWatchingState {
  @override
  List<Object?> get props => [];
}

class GetContinueWatchingLoadedState extends GetContinueWatchingState {
  final ContinueWatchingModel model;
  GetContinueWatchingLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetContinueWatchingErrorState extends GetContinueWatchingState {
  final String error;
  GetContinueWatchingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
