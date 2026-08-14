import 'package:equatable/equatable.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  final bool isMerchant;

  const OrdersLoaded(this.orders, {this.isMerchant = false});

  @override
  List<Object?> get props => [orders, isMerchant];
}

class OrdersFail extends OrdersState {
  final String message;

  const OrdersFail(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Status Update ---
class OrderStatusUpdateLoading extends OrdersState {
  const OrderStatusUpdateLoading();
}

class OrderStatusUpdateSuccess extends OrdersState {
  const OrderStatusUpdateSuccess();
}

class OrderStatusUpdateFail extends OrdersState {
  final String message;
  const OrderStatusUpdateFail(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Review ---
class OrderReviewLoading extends OrdersState {
  const OrderReviewLoading();
}

class OrderReviewSuccess extends OrdersState {
  const OrderReviewSuccess();
}

class OrderReviewFail extends OrdersState {
  final String message;
  const OrderReviewFail(this.message);

  @override
  List<Object?> get props => [message];
}
