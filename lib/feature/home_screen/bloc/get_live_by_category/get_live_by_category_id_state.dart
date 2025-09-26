part of 'get_live_by_category_id_cubit.dart';

sealed class GetLiveByCategoryIdState extends Equatable {}

final class GetLiveByCategoryIdInitial extends GetLiveByCategoryIdState {
  @override
  List<Object?> get props => [];
}

final class GetLiveByCategoryIdLoadingState extends GetLiveByCategoryIdState {
  @override
  List<Object?> get props => [];
}

final class GetLiveByCategoryIdLoadedState extends GetLiveByCategoryIdState {
    final GetLiveModel model;
    GetLiveByCategoryIdLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetLiveByCategoryIdErrorState extends GetLiveByCategoryIdState {
  final String error;
  GetLiveByCategoryIdErrorState(this.error);
  @override
  List<Object?> get props => [error];
}