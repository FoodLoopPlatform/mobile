import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentUrlLoaded extends PaymentState {
  final String checkoutUrl;

  const PaymentUrlLoaded(this.checkoutUrl);

  @override
  List<Object> get props => [checkoutUrl];
}

class PaymentError extends PaymentState {
  final String errorMessage;

  const PaymentError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PaymentWalletSuccess extends PaymentState {}
