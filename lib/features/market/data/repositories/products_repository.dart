import 'package:dio/dio.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/market/data/data_sources/products_remote_data_source.dart';
import 'package:foodloop/features/market/data/models/products_page.dart';

class ProductsRepository {
  final ProductsRemoteDataSource _remoteDataSource;

  ProductsRepository(this._remoteDataSource);

  Future<ProductsPage> getProducts({
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
    try {
      return await _remoteDataSource.getProducts(
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
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is Errors) rethrow;
      throw ServerError(AppStrings.errorUnknown);
    }
  }
}
