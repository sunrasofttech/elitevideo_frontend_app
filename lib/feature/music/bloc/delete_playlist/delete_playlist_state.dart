part of 'delete_playlist_cubit.dart';

sealed class DeletePlaylistState extends Equatable {}

final class DeletePlaylistInitial extends DeletePlaylistState {
  @override
  List<Object?> get props => [];
}

final class DeletePlaylistLoadingState extends DeletePlaylistState {
  @override
  List<Object?> get props => [];
}

final class DeletePlaylistLoadedState extends DeletePlaylistState {
  @override
  List<Object?> get props => [];
}

final class DeletePlaylistErrorState extends DeletePlaylistState {
  final String error;
  DeletePlaylistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}