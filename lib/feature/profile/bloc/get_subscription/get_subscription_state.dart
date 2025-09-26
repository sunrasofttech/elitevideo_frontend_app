part of 'get_subscription_cubit.dart';

abstract class GetSubscriptionState extends Equatable {}

class GetSubscriptionInitial extends GetSubscriptionState {
  @override
  List<Object?> get props => [];
}


class GetSubscriptionLoadingState extends GetSubscriptionState {
  @override
  List<Object?> get props => [];
}

class GetSubscriptionLoadedState extends GetSubscriptionState {
  final GetAllSubscriptionModel model;
  GetSubscriptionLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

class GetSubscriptionErrorState extends GetSubscriptionState {
  final String error;
  GetSubscriptionErrorState(this.error);
  @override
  List<Object?> get props => [error];
}