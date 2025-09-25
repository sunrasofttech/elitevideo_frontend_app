part of 'get_highlighted_content_cubit.dart';

sealed class GetHighlightedContentState extends Equatable {}

final class GetHighlightedContentInitial extends GetHighlightedContentState {
  @override
  List<Object?> get props => [];
}

final class GetHighlightedContentLoadingState extends GetHighlightedContentState {
  @override
  List<Object?> get props => [];
}

final class GetHighlightedContentLoadedState extends GetHighlightedContentState {
  final GetHighlightedContentModel model;
  GetHighlightedContentLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class GetHighlightedContentErrorState extends GetHighlightedContentState {
  final String error;
  GetHighlightedContentErrorState(this.error);
  @override
  List<Object?> get props => [error];
}