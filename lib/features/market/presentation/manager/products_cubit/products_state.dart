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
  final bool isFetchingMore;
  final bool hasReachedMax;

  const ProductsLoaded({
    required this.page,
    this.isFetchingMore = false,
    this.hasReachedMax = false,
  });

  ProductsLoaded copyWith({
    ProductsPage? page,
    bool? isFetchingMore,
    bool? hasReachedMax,
  }) {
    return ProductsLoaded(
      page: page ?? this.page,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [page, isFetchingMore, hasReachedMax];
}

class ProductsFail extends ProductsState {
  final String message;
  const ProductsFail({required this.message});

  @override
  List<Object?> get props => [message];
}
