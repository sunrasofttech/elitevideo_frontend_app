part of 'get_all_short_film_cubit.dart';

abstract class GetAllShortFilmState extends Equatable {}

class GetAllShortFilmInitial extends GetAllShortFilmState {
  @override
  List<Object?> get props => [];
}

class GetAllShortFilmLoadingState extends GetAllShortFilmState {
  @override
  List<Object?> get props => [];
}

class GetAllShortFilmLoadedState extends GetAllShortFilmState {
  final GetAllShortFilmModel model;
  GetAllShortFilmLoadedState(this.model);
  @override
  List<Object?> get props => [];
}

class GetAllShortFilmErrorState extends GetAllShortFilmState {
  final String error;
  GetAllShortFilmErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
