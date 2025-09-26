part of 'post_series_rating_cubit.dart';

abstract class PostSeriesRatingState extends Equatable {}

class PostSeriesRatingInitial extends PostSeriesRatingState {
  @override
  List<Object?> get props => [];
}

class PostSeriesRatingLoadingState extends PostSeriesRatingState {
  @override
  List<Object?> get props => [];
}

class PostSeriesRatingLoadedState extends PostSeriesRatingState {
  @override
  List<Object?> get props => [];
}

class PostSeriesRatingErrorState extends PostSeriesRatingState {
  final String error;
  PostSeriesRatingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
