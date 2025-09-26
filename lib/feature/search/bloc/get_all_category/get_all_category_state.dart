part of 'get_all_category_cubit.dart';

sealed class GetAllCategoryState extends Equatable {}

final class GetAllCategoryInitial extends GetAllCategoryState {
  @override
  List<Object?> get props => [];
}

final class GetAllCategoryLoadingState extends GetAllCategoryState {
  @override
  List<Object?> get props => [];
}

final class GetAllCategoryLoadedState extends GetAllCategoryState {
  final GetAllMovieCategoryModel model;
  GetAllCategoryLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllCategoryErrorState extends GetAllCategoryState {
  final String error;
  GetAllCategoryErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
