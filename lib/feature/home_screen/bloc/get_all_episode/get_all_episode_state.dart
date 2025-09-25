part of 'get_all_episode_cubit.dart';

abstract class GetAllEpisodeState extends Equatable {}

class GetAllEpisodeInitial extends GetAllEpisodeState {
  @override
  List<Object?> get props => [];
}

class GetAllEpisodeLoadingState extends GetAllEpisodeState {
  @override
  List<Object?> get props => [];
}

class GetAllEpisodeLoadedState extends GetAllEpisodeState {
  final GetEpisodeModel model;
  GetAllEpisodeLoadedState(this.model);
  @override
  List<Object?> get props => [];
}

class GetAllEpisodeErrorState extends GetAllEpisodeState {
  final String error;
  GetAllEpisodeErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
