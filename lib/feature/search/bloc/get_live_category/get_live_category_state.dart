part of 'get_live_category_cubit.dart';

sealed class GetLiveCategoryState extends Equatable {}

final class GetLiveCategoryInitial extends GetLiveCategoryState {
  @override
  List<Object?> get props => [];
}


final class GetLiveCategoryLoadingState extends GetLiveCategoryState {
  @override
  List<Object?> get props => [];
}


final class GetLiveCategoryLoadedState extends GetLiveCategoryState {
  final GetLiveCategoryModel model;
  GetLiveCategoryLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}


final class GetLiveCategoryErrorState extends GetLiveCategoryState {
  final String error;
  GetLiveCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
