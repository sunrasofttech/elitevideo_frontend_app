part of 'get_movie_by_id_cubit.dart';

abstract class GetMovieByIdState extends Equatable {}

class GetMovieByIdInitial extends GetMovieByIdState {
  @override
  List<Object?> get props => [];
}

class GetMovieByIdLoadingState extends GetMovieByIdState {
  @override
  List<Object?> get props => [];
}

class GetMovieByIdLoadedState extends GetMovieByIdState {
 final GetMovieByIdModel model;
  GetMovieByIdLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetMovieByIdErrorState extends GetMovieByIdState {
  final String error;
  GetMovieByIdErrorState(this.error);
  @override
  List<Object?> get props => [error];
}