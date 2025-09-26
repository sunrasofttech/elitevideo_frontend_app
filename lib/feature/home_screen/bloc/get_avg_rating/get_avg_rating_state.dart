part of 'get_avg_rating_cubit.dart';

abstract class GetAvgRatingState extends Equatable {}

class GetAvgRatingInitial extends GetAvgRatingState {
  @override
  List<Object?> get props => [];
}


class GetAvgRatingLoadingState extends GetAvgRatingState {
  @override
  List<Object?> get props => [];
}


class GetAvgRatingLoadedState extends GetAvgRatingState {
  final GetRatingInfoModel model;
  GetAvgRatingLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}


class GetAvgRatingErrorState extends GetAvgRatingState {
  final String error;
  GetAvgRatingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}