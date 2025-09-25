part of 'get_popular_music_cubit.dart';

sealed class GetPopularMusicState extends Equatable {}

final class GetPopularMusicInitial extends GetPopularMusicState {
  @override
  List<Object?> get props => [];
}

final class GetPopularMusicLoadingState extends GetPopularMusicState {
  @override
  List<Object?> get props => [];
}

final class GetPopularMusicLoadedState extends GetPopularMusicState {
  final GetPopularMusicModel model;
  GetPopularMusicLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetPopularMusicErrorState extends GetPopularMusicState {
  final String error;
  GetPopularMusicErrorState(this.error);
  @override
  List<Object?> get props => [error];
}