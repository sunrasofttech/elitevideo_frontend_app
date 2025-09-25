part of 'post_movie_rating_cubit.dart';

abstract class PostMovieRatingState extends Equatable {}

class PostMovieRatingInitial extends PostMovieRatingState {
  @override
  List<Object?> get props => [];
}

class PostMovieRatingLoadingState extends PostMovieRatingState {
  @override
  List<Object?> get props => [];
}

class PostMovieRatingLoadedState extends PostMovieRatingState {
  @override
  List<Object?> get props => [];
}

class PostMovieRatingErrorState extends PostMovieRatingState {
  final String error;
  PostMovieRatingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}