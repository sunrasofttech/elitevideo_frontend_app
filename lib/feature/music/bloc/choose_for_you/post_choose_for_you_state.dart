part of 'post_choose_for_you_cubit.dart';

sealed class PostChooseForYouState extends Equatable {}

final class PostChooseForYouInitial extends PostChooseForYouState {
  @override
  List<Object?> get props => [];
}

final class PostChooseForYouLoadingState extends PostChooseForYouState {
  @override
  List<Object?> get props => [];
}

final class PostChooseForYouLoadedState extends PostChooseForYouState {
  @override
  List<Object?> get props => [];
}

final class ServerDown extends PostChooseForYouState {
  @override
  List<Object?> get props => [];
}

final class PostChooseForYouErrorState extends PostChooseForYouState {
  final String error;
  PostChooseForYouErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
