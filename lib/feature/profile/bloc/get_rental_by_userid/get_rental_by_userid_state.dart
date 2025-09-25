part of 'get_rental_by_userid_cubit.dart';

abstract class GetRentalByUseridState extends Equatable {}

 class GetRentalByUseridInitial extends GetRentalByUseridState {
  @override
  List<Object?> get props => [];
}

 class GetRentalByUseridLoadingState extends GetRentalByUseridState {
  @override
  List<Object?> get props => [];
}

 class GetRentalByUseridLoadedState extends GetRentalByUseridState {
  final GetRentalModel model;
  GetRentalByUseridLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

 class GetRentalByUseridErrorState extends GetRentalByUseridState {
  final String error;
  GetRentalByUseridErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
