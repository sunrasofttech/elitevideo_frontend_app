part of 'get_resent_search_cubit.dart';

sealed class GetResentSearchState extends Equatable {}

final class GetResentSearchInitial extends GetResentSearchState {
  @override
  List<Object?> get props => [];
}

final class GetResentSearchLoadingState extends GetResentSearchState {
  @override
  List<Object?> get props => [];
}

final class GetResentSearchLoadedState extends GetResentSearchState {
  final ResentSearchModel model;
  GetResentSearchLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetResentSearchErrorState extends GetResentSearchState {
  final String error;
  GetResentSearchErrorState(this.error);
  @override
  List<Object?> get props => [error];
}