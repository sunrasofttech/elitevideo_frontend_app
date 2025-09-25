part of 'post_report_cubit.dart';

abstract class PostReportState extends Equatable {}

class PostReportInitial extends PostReportState {
  @override
  List<Object?> get props => [];
}

class PostReportLoadingState extends PostReportState {
  @override
  List<Object?> get props => [];
}

class PostReportLoadedState extends PostReportState {
  @override
  List<Object?> get props => [];
}

class PostReportErrorState extends PostReportState {
  final String error;
  PostReportErrorState(this.error);
  @override
  List<Object?> get props => [];
}
