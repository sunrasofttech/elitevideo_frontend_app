part of 'create_order_cubit.dart';

sealed class CreateOrderState extends Equatable {}

final class CreateOrderInitial extends CreateOrderState {
  @override
  List<Object?> get props => [];
}

final class CreateOrderLoadingState extends CreateOrderState {
  @override
  List<Object?> get props => [];
}

final class CreateOrderLoadedState extends CreateOrderState {
  final CreateOrderModel model;
  CreateOrderLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}

final class CreateOrderErrorState extends CreateOrderState {
  final String error;
  CreateOrderErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
