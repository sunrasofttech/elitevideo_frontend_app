part of 'abc_gateway_cubit.dart';

sealed class AbcGatewayState extends Equatable {}

final class AbcGatewayInitial extends AbcGatewayState {
  @override
  List<Object?> get props => [];
}

final class AbcGatewayLoadingState extends AbcGatewayState {
  @override
  List<Object?> get props => [];
}


final class AbcGatewayLoadedState extends AbcGatewayState {
  final AbcGatewayModel model;
  AbcGatewayLoadedState(this.model);
  @override
  List<Object?> get props => [model];
}


final class AbcGatewayErrorState extends AbcGatewayState {
  final String error;
  AbcGatewayErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
