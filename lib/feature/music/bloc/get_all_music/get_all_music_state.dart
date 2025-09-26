part of 'get_all_music_cubit.dart';

abstract class GetAllMusicState extends Equatable {}

class GetAllMusicInitial extends GetAllMusicState {
  @override
  List<Object?> get props => [];
}

class GetAllMusicLoadingState extends GetAllMusicState {
  @override
  List<Object?> get props => [];
}

class GetAllMusicLoadedState extends GetAllMusicState {
  final GetMusicModel model;
  GetAllMusicLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetAllMusicErrorState extends GetAllMusicState {
  final String error;
  GetAllMusicErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
