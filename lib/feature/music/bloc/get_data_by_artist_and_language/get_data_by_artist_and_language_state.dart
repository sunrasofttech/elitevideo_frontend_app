part of 'get_data_by_artist_and_language_cubit.dart';

sealed class GetDataByArtistAndLanguageState extends Equatable {}

final class GetDataByArtistAndLanguageInitial extends GetDataByArtistAndLanguageState {
  @override
  List<Object?> get props => [];
}

final class GetDataByArtistAndLanguageLoadingState extends GetDataByArtistAndLanguageState {
  @override
  List<Object?> get props => [];
}


final class GetDataByArtistAndLanguageLoadedState extends GetDataByArtistAndLanguageState {
  final GetDataByArtistIdAndLanguageIdModel model;
  GetDataByArtistAndLanguageLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}


final class GetDataByArtistAndLanguageErrorState extends GetDataByArtistAndLanguageState {
  final String error;
  GetDataByArtistAndLanguageErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
