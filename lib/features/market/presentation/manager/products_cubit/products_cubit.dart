import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/features/market/data/repositories/products_repository.dart';
import 'package:foodloop/features/market/data/models/products_page.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepository _productsRepository;

  // Store current query parameters for pagination
  double? _latitude;
  double? _longitude;
  double? _maxDistance;
  String? _categoryId;
  double? _minPrice;
  double? _maxPrice;
  String? _search;
  String? _sortBy;
  int _pageNumber = 1;
  int _pageSize = 10;

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
    _latitude = latitude;
    _longitude = longitude;
    _maxDistance = maxDistance;
    _categoryId = categoryId;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _search = search;
    _sortBy = sortBy;
    _pageNumber = pageNumber;
    _pageSize = pageSize;

    emit(const ProductsLoading());
    try {
      final page = await _productsRepository.getProducts(
        latitude: _latitude,
        longitude: _longitude,
        maxDistance: _maxDistance,
        categoryId: _categoryId,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        search: _search,
        sortBy: _sortBy,
        pageNumber: _pageNumber,
        pageSize: _pageSize,
      );
      
      final hasReachedMax = page.items.length < _pageSize;
      emit(ProductsLoaded(page: page, hasReachedMax: hasReachedMax));
    } on Errors catch (e) {
      emit(ProductsFail(message: e.errMessage));
    } catch (e) {
      emit(ProductsFail(message: e.toString()));
    }
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;
    if (currentState is! ProductsLoaded) return;
    if (currentState.hasReachedMax || currentState.isFetchingMore) return;

    emit(currentState.copyWith(isFetchingMore: true));
    
    _pageNumber++;

    try {
      final newPage = await _productsRepository.getProducts(
        latitude: _latitude,
        longitude: _longitude,
        maxDistance: _maxDistance,
        categoryId: _categoryId,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        search: _search,
        sortBy: _sortBy,
        pageNumber: _pageNumber,
        pageSize: _pageSize,
      );

      final hasReachedMax = newPage.items.length < _pageSize;
      
      final combinedItems = [
        ...currentState.page.items,
        ...newPage.items,
      ];
      
      final updatedPage = ProductsPage(
        items: combinedItems,
        pageNumber: newPage.pageNumber,
        pageSize: newPage.pageSize,
        totalCount: newPage.totalCount,
        hasNextPage: newPage.hasNextPage,
      );

      emit(ProductsLoaded(
        page: updatedPage,
        hasReachedMax: hasReachedMax,
        isFetchingMore: false,
      ));
    } on Errors catch (e) {
      emit(currentState.copyWith(isFetchingMore: false));
      // Optionally handle error (e.g. show a snackbar in UI instead of full fail)
    } catch (e) {
      emit(currentState.copyWith(isFetchingMore: false));
    }
  }
}
