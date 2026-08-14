import 'package:equatable/equatable.dart';
import 'package:foodloop/features/cart/data/models/cart_item_model.dart';
import 'package:foodloop/features/cart/data/models/order_response_model.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;

  const CartLoaded({
    required this.items,
    required this.subtotal,
    this.deliveryFee = 25.0,
    this.discount = 0.0,
  });

  double get grandTotal => subtotal + deliveryFee - discount;

  @override
  List<Object?> get props => [items, subtotal, deliveryFee, discount];
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartOrderSuccess extends CartState {
  final OrderResponseModel response;
  const CartOrderSuccess({required this.response});
  @override
  List<Object?> get props => [response];
}

class CartError extends CartState {
  final String message;
  const CartError({required this.message});
  @override
  List<Object?> get props => [message];
}
