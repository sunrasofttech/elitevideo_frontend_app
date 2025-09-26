part of 'short_film_rate_cubit.dart';

abstract class ShortFilmRateState extends Equatable {}

class ShortFilmRateInitial extends ShortFilmRateState {
  @override
  List<Object?> get props => [];
}

class ShortFilmRateLoadingState extends ShortFilmRateState {
  @override
  List<Object?> get props => [];
}

class ShortFilmRateLoadedState extends ShortFilmRateState {
  @override
  List<Object?> get props => [];
}

class ShortFilmRateErrorState extends ShortFilmRateState {
  final String error;
  ShortFilmRateErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
