part of 'get_webseries_by_id_cubit.dart';

sealed class GetWebseriesByIdState extends Equatable {}

final class GetWebseriesByIdInitial extends GetWebseriesByIdState {
  @override
  List<Object?> get props => [];
}

final class GetWebseriesByIdLoadingState extends GetWebseriesByIdState {
  @override
  List<Object?> get props => [];
}

final class GetWebseriesByIdLoadedState extends GetWebseriesByIdState {
  final GetWebseriesByModelModel model;
  GetWebseriesByIdLoadedState(this.model);
  @override
  List<Object?> get props => [];
}

final class GetWebseriesByIdErrorState extends GetWebseriesByIdState {
  final String error;
  GetWebseriesByIdErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
