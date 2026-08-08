import 'package:equatable/equatable.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';

/// One page of `GET /marketplace/products`.
class ProductsPage extends Equatable {
  final List<ProductModel> items;
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final bool hasNextPage;

  const ProductsPage({
    required this.items,
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.hasNextPage,
  });

  @override
  List<Object?> get props =>
      [items, pageNumber, pageSize, totalCount, hasNextPage];
}
