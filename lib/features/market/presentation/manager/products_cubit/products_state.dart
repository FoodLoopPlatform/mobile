import 'package:equatable/equatable.dart';
import 'package:foodloop/features/market/data/models/products_page.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final ProductsPage page;
  const ProductsLoaded({required this.page});

  @override
  List<Object?> get props => [page];
}

class ProductsFail extends ProductsState {
  final String message;
  const ProductsFail({required this.message});

  @override
  List<Object?> get props => [message];
}
