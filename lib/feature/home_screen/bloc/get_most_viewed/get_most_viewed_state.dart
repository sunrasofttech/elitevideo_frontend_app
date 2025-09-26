part of 'get_most_viewed_cubit.dart';

abstract class GetMostViewedState extends Equatable {}

class GetMostViewedInitial extends GetMostViewedState {
  @override
  List<Object?> get props => [];
}

class GetMostViewedLoadingState extends GetMostViewedState {
  @override
  List<Object?> get props => [];
}

class GetMostViewedLoadedState extends GetMostViewedState {
  final MostViewedModel model;
  GetMostViewedLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetMostViewedErrorState extends GetMostViewedState {
  final String error;
  GetMostViewedErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
