part of 'get_movie_by_category_id_cubit.dart';

sealed class GetMovieByCategoryIdState extends Equatable {}

final class GetMovieByCategoryIdInitial extends GetMovieByCategoryIdState {
  @override
  List<Object?> get props => [];
}

final class GetMovieByCategoryIdLoadingState extends GetMovieByCategoryIdState {
  @override
  List<Object?> get props => [];
}


final class GetMovieByCategoryIdLoadedState extends GetMovieByCategoryIdState {
  final GetAllMoviesModel model;
  GetMovieByCategoryIdLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}


final class GetMovieByCategoryIdErrorState extends GetMovieByCategoryIdState {
  final String error;
  GetMovieByCategoryIdErrorState(this.error);
  @override
  List<Object?> get props => [error];
}

