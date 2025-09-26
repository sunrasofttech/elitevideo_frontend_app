part of 'get_cast_crew_cubit.dart';

abstract class GetCastCrewState extends Equatable {}

class GetCastCrewInitial extends GetCastCrewState {
  @override
  List<Object?> get props => [];
}

class GetCastCrewLoadingState extends GetCastCrewState {
  @override
  List<Object?> get props => [];
}

class GetCastCrewLoadedState extends GetCastCrewState {
  final GetCastCrewModel model;
  GetCastCrewLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetCastCrewErrorState extends GetCastCrewState {
  final String error;
  GetCastCrewErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
