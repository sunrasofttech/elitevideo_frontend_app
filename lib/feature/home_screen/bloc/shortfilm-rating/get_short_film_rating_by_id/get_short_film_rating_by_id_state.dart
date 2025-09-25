part of 'get_short_film_rating_by_id_cubit.dart';

abstract class GetShortFilmRatingByIdState extends Equatable {}

class GetShortFilmRatingByIdInitial extends GetShortFilmRatingByIdState {
  @override
  List<Object?> get props => [];
}

class GetShortFilmRatingByIdLoadingState extends GetShortFilmRatingByIdState {
  @override
  List<Object?> get props => [];
}

class GetShortFilmRatingByIdLoadedState extends GetShortFilmRatingByIdState {
  final GetShortFilmRatingByIdModel model;
  GetShortFilmRatingByIdLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetShortFilmRatingByIdErrorState extends GetShortFilmRatingByIdState {
  final String error;
  GetShortFilmRatingByIdErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
