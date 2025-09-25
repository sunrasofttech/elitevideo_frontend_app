part of 'get_series_castcrew_cubit.dart';

abstract class GetSeriesCastcrewState extends Equatable {}

class GetSeriesCastcrewInitial extends GetSeriesCastcrewState {
  @override
  List<Object?> get props => [];
}

class GetSeriesCastcrewLoadingState extends GetSeriesCastcrewState {
  @override
  List<Object?> get props => [];
}

class GetSeriesCastcrewLoadedState extends GetSeriesCastcrewState {
  final GetSeriesCastCrewModel model;
  GetSeriesCastcrewLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetSeriesCastcrewErrorState extends GetSeriesCastcrewState {
  final String error;
  GetSeriesCastcrewErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
