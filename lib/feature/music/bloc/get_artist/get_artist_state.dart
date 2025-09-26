part of 'get_artist_cubit.dart';

sealed class GetArtistState extends Equatable {}

final class GetArtistInitial extends GetArtistState {
  @override
  List<Object?> get props => [];
}

final class GetArtistLoadingState extends GetArtistState {
  @override
  List<Object?> get props => [];
}

final class GetArtistLoadedState extends GetArtistState {
  final GetAllArtistModel model;
  GetArtistLoadedState(this.model);
  @override
  List<Object?> get props => [];
}

final class GetArtistErrorState extends GetArtistState {
  final String error;
  GetArtistErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
