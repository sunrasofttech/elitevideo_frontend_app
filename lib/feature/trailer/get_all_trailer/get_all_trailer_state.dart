part of 'get_all_trailer_cubit.dart';

sealed class GetAllTrailerState extends Equatable {}

final class GetAllTrailerInitial extends GetAllTrailerState {
  @override
  List<Object?> get props => [];
}

final class GetAllTrailerLoadingState extends GetAllTrailerState {
  @override
  List<Object?> get props => [];
}

final class GetAllTrailerLoadedState extends GetAllTrailerState {
  final GetAllTrailorsModel model;
  GetAllTrailerLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllTrailerErrorState extends GetAllTrailerState {
  final String error;
  GetAllTrailerErrorState(this.error);
  @override
  List<Object?> get props => [error];
}