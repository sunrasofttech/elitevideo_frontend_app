part of 'add_song_in_playlist_cubit.dart';

sealed class AddSongInPlaylistState extends Equatable {}

final class AddSongInPlaylistInitial extends AddSongInPlaylistState {
  @override
  List<Object?> get props => [];
}

final class AddSongInPlaylistLoadingState extends AddSongInPlaylistState {
  @override
  List<Object?> get props => [];
}

final class AddSongInPlaylistLoadedState extends AddSongInPlaylistState {
  @override
  List<Object?> get props => [];
}

final class AddSongInPlaylistErrorState extends AddSongInPlaylistState {
  final String error;
  AddSongInPlaylistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}