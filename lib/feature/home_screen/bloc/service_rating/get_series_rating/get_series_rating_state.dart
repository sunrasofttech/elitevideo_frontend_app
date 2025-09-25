part of 'get_series_rating_cubit.dart';

abstract class GetSeriesRatingState extends Equatable {}

class GetSeriesRatingInitial extends GetSeriesRatingState {
  @override
  List<Object?> get props => [];
}

class GetSeriesRatingLoadingState extends GetSeriesRatingState {
  @override
  List<Object?> get props => [];
}

class GetSeriesRatingLoadedState extends GetSeriesRatingState {
  final GetSeriesRatingByIdModel model;
  GetSeriesRatingLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetSeriesRatingErrorState extends GetSeriesRatingState {
  final String error;
  GetSeriesRatingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
