part of 'get_all_tv_show_cubit.dart';

sealed class GetAllTVSeriesState extends Equatable {}

final class GetAllTVSeriesInitial extends GetAllTVSeriesState {
  @override
  List<Object?> get props => [];
}

final class GetAllTVSeriesLoadingState extends GetAllTVSeriesState {
  @override
  List<Object?> get props => [];
}

final class GetAllTVSeriesLoadedState extends GetAllTVSeriesState {
  final GetSeriesModel model;
  GetAllTVSeriesLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllTVSeriesErrorState extends GetAllTVSeriesState {
  final String error;
  GetAllTVSeriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
