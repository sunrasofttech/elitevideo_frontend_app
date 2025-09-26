part of 'search_cubit.dart';

sealed class SearchState extends Equatable {}

final class SearchInitial extends SearchState {
  @override
  List<Object?> get props => [];
}

final class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}

final class SearchLoadedState extends SearchState {
  final SearchModel model;
  SearchLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class SearchErrorState extends SearchState {
  final String error;
  SearchErrorState(this.error);
  @override
  List<Object?> get props => [error];
}