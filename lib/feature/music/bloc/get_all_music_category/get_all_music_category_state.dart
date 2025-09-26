part of 'get_all_music_category_cubit.dart';

abstract class GetAllMusicCategoryState extends Equatable {}

class GetAllMusicCategoryInitial extends GetAllMusicCategoryState {
  @override
  List<Object?> get props => [];
}

class GetAllMusicCategoryLoadingState extends GetAllMusicCategoryState {
  @override
  List<Object?> get props => [];
}

class GetAllMusicCategoryLoadedState extends GetAllMusicCategoryState {
  final GetAllMusicModel model;
  GetAllMusicCategoryLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetAllMusicCategoryErrorState extends GetAllMusicCategoryState {
  final String error;
  GetAllMusicCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
