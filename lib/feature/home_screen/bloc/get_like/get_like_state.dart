part of 'get_like_cubit.dart';

abstract class GetLikeState extends Equatable {}

class GetLikeInitial extends GetLikeState {
  @override
  List<Object?> get props => [];
}

class GetLikeLoadingState extends GetLikeState {
  @override
  List<Object?> get props => [];
}

class GetLikeLoadedState extends GetLikeState {
  final GetLikedModel model;
  GetLikeLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetLikeErrorState extends GetLikeState {
  final String error;
  GetLikeErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
