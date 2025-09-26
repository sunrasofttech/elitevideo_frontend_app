part of 'get_live_tv_cubit.dart';

abstract class GetLiveTvState extends Equatable {}

class GetLiveTvInitial extends GetLiveTvState {
  @override
  List<Object?> get props => [];
}

class GetLiveTvLoadingState extends GetLiveTvState {
  @override
  List<Object?> get props => [];
}

class GetLiveTvLoadedState extends GetLiveTvState {
  final GetLiveModel model;
  GetLiveTvLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetLiveTvErrorState extends GetLiveTvState {
  final String error;
  GetLiveTvErrorState(this.error);
  @override
  List<Object?> get props => [error];
}