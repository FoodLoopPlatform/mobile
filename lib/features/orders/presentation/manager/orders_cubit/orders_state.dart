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

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrdersFail extends OrdersState {
  final String message;

  const OrdersFail(this.message);

  @override
  List<Object?> get props => [message];
}
