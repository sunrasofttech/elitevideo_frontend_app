part of 'post_playlist_cubit.dart';

sealed class PostPlaylistState extends Equatable {}

final class PostPlaylistInitial extends PostPlaylistState {
  @override
  List<Object?> get props => [];
}

final class PostPlaylistLoadingState extends PostPlaylistState {
  @override
  List<Object?> get props => [];
}

final class PostPlaylistLoadedState extends PostPlaylistState {
  @override
  List<Object?> get props => [];
}

final class ServerDown extends PostPlaylistState {
  @override
  List<Object?> get props => [];
}


final class PostPlaylistErrorState extends PostPlaylistState {
  final String error;
  PostPlaylistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}