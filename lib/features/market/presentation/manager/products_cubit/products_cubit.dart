import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/features/market/data/repositories/products_repository.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _productsRepository;

  ProductsCubit(this._productsRepository) : super(const ProductsInitial());

  Future<void> loadProducts({
    double? latitude,
    double? longitude,
    double? maxDistance,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? search,
    String? sortBy,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    emit(const ProductsLoading());
    try {
      final page = await _productsRepository.getProducts(
        latitude: latitude,
        longitude: longitude,
        maxDistance: maxDistance,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        search: search,
        sortBy: sortBy,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      emit(ProductsLoaded(page: page));
    } on Errors catch (e) {
      emit(ProductsFail(message: e.errMessage));
    } catch (e) {
      emit(ProductsFail(message: e.toString()));
    }
  }
}
