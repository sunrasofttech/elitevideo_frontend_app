part of 'get_shortfilm_by_id_cubit.dart';

abstract class GetShortfilmByIdState extends Equatable {}

class GetShortfilmByIdInitial extends GetShortfilmByIdState {
  @override
  List<Object?> get props => [];
}

class GetShortfilmByIdLoadingState extends GetShortfilmByIdState {
  @override
  List<Object?> get props => [];
}

class GetShortfilmByIdLoadedState extends GetShortfilmByIdState {
 final GetShortFilmByIdModel model;
  GetShortfilmByIdLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetShortfilmByIdErrorState extends GetShortfilmByIdState {
  final String error;
  GetShortfilmByIdErrorState(this.error);
  @override
  List<Object?> get props => [error];
}