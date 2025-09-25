part of 'get_all_language_cubit.dart';

sealed class GetAllLanguageState extends Equatable {}

final class GetAllLanguageInitial extends GetAllLanguageState {
  @override
  List<Object?> get props => [];
}

final class GetAllLanguageLoadingState extends GetAllLanguageState {
  @override
  List<Object?> get props => [];
}

final class GetAllLanguageLoadedState extends GetAllLanguageState {
  final GetMovieLanguageModel model;
  GetAllLanguageLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetAllLanguageErrorState extends GetAllLanguageState {
  final String error;
  GetAllLanguageErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
