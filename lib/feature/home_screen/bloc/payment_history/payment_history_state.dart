part of 'payment_history_cubit.dart';

sealed class PaymentHistoryState extends Equatable {}

final class PaymentHistoryInitial extends PaymentHistoryState {
@override
List<Object?> get props => [];
}

final class PaymentHistoryLoadingState extends PaymentHistoryState {
@override
List<Object?> get props => [];
}

final class PaymentHistoryLoadedState extends PaymentHistoryState {
@override
List<Object?> get props => [];
}

final class PaymentHistoryErrorState extends PaymentHistoryState {
  final String error;
  PaymentHistoryErrorState(this.error);
@override
List<Object?> get props => [error];
}
