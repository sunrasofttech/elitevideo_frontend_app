part of 'get_choose_for_you_cubit.dart';

sealed class GetChooseForYouState extends Equatable {}

final class GetChooseForYouInitial extends GetChooseForYouState {
  @override
  List<Object?> get props => [];
}

final class GetChooseForYouLoadingState extends GetChooseForYouState {
  @override
  List<Object?> get props => [];
}

final class GetChooseForYouLoadedState extends GetChooseForYouState {
  final GetChooseForYouModel model;
  GetChooseForYouLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}


final class GetChooseForYouErrorState extends GetChooseForYouState {
  final String error;
  GetChooseForYouErrorState(this.error);
  @override
  List<Object?> get props => [error];
}