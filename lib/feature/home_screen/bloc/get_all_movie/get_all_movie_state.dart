part of 'get_all_movie_cubit.dart';

abstract class GetAllMovieState extends Equatable {}

class GetAllMovieInitial extends GetAllMovieState {
  @override
  List<Object?> get props => [];
}

class GetAllMovieLoadingState extends GetAllMovieState {
  @override
  List<Object?> get props => [];
}

class GetAllMovieLaodedState extends GetAllMovieState {
  final GetAllMoviesModel model;
  GetAllMovieLaodedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetAllMovieErrorState extends GetAllMovieState {
  final String error;
  GetAllMovieErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
