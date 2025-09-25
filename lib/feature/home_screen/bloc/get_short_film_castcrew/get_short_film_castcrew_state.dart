part of 'get_short_film_castcrew_cubit.dart';

abstract class GetShortFilmCastcrewState extends Equatable {}

class GetShortFilmCastcrewInitial extends GetShortFilmCastcrewState {
  @override
  List<Object?> get props => [];
}

class GetShortFilmCastcrewLoadingState extends GetShortFilmCastcrewState {
  @override
  List<Object?> get props => [];
}


class GetShortFilmCastcrewLoadedState extends GetShortFilmCastcrewState {
 final GetShortFiImCastCrewModel model;
  GetShortFilmCastcrewLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}


class GetShortFilmCastcrewErrorState extends GetShortFilmCastcrewState {
  final String error;
  GetShortFilmCastcrewErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
