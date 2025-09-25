part of 'get_all_playlist_cubit.dart';

sealed class GetAllPlaylistState extends Equatable {}

final class GetAllPlaylistInitial extends GetAllPlaylistState {
  @override
  List<Object?> get props => [];
}

final class GetAllPlaylistLoadingState extends GetAllPlaylistState {
  @override
  List<Object?> get props => [];
}

final class GetAllPlaylistLoadedState extends GetAllPlaylistState {
  final GetPlaylistModel model;
  GetAllPlaylistLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllPlaylistErrorState extends GetAllPlaylistState {
  final String error;
  GetAllPlaylistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}