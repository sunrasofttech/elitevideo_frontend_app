part of 'get_all_series_cubit.dart';

abstract class GetAllSeriesState extends Equatable {}

class GetAllSeriesInitial extends GetAllSeriesState {
  @override
  List<Object?> get props => [];
}

class GetAllSeriesLoadingState extends GetAllSeriesState {
  @override
  List<Object?> get props => [];
}

class GetAllSeriesLoadedState extends GetAllSeriesState {
  final GetSeriesModel model;
  GetAllSeriesLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetAllSeriesErrorState extends GetAllSeriesState {
  final String error;
  GetAllSeriesErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
