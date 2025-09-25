part of 'get_setting_cubit.dart';

abstract class GetSettingState extends Equatable {}

class GetSettingInitial extends GetSettingState {
  @override
  List<Object?> get props => [];
}

class GetSettingLoadingState extends GetSettingState {
  @override
  List<Object?> get props => [];
}

class GetSettingLoadedState extends GetSettingState {
  final GetSettingModel model;
  GetSettingLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetSettingErrorState extends GetSettingState {
  final String error;
  GetSettingErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
