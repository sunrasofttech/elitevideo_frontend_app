part of 'highlighted_movie_cubit.dart';

abstract class HighlightedMovieState extends Equatable {}

class HighlightedMovieInitial extends HighlightedMovieState {
  @override
  List<Object?> get props => [];
}


class HighlightedMovieLoadingState extends HighlightedMovieState {
  @override
  List<Object?> get props => [];
}

class HighlightedMovieLoadedState extends HighlightedMovieState {
  final HighlightedMovieModel model;
  HighlightedMovieLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class HighlightedMovieErrorState extends HighlightedMovieState {
  final String error;
  HighlightedMovieErrorState(this.error);
  @override
  List<Object?> get props => [error];
}