import 'package:dio/dio.dart';
import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/data/models/products_page.dart';

class ProductsRemoteDataSource {
  final ApiManager _apiManager;

  ProductsRemoteDataSource(this._apiManager);

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
    final query = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (maxDistance != null) 'maxDistance': maxDistance,
      if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (search != null && search.isNotEmpty) 'search': search,
      if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
    };

    final response = await _apiManager.get(
      ApiConstants.marketplaceProductsEndpoint,
      queryParameters: query,
    );
    return _parse(
      response.data,
      fallbackPageNumber: pageNumber,
      fallbackPageSize: pageSize,
    );
  }

  Future<void> reportProduct({
    required String productId,
    required String reason,
    required String details,
    required String imagePath,
  }) async {
    final formData = FormData.fromMap({
      'Reason': reason,
      'Details': details,
      'Image': await MultipartFile.fromFile(imagePath),
    });
    await _apiManager.post(ApiConstants.reportProductEndpoint(productId), formData);
  }

  /// The envelope isn't documented, so a bare array, `{data: [...]}` and
  /// `{data: {items: [...], totalCount, ...}}` are all accepted.
  ProductsPage _parse(
    dynamic body, {
    required int fallbackPageNumber,
    required int fallbackPageSize,
  }) {
    if (body is List) {
      final items = _mapList(body);
      return ProductsPage(
        items: items,
        pageNumber: fallbackPageNumber,
        pageSize: fallbackPageSize,
        totalCount: items.length,
        hasNextPage: items.length >= fallbackPageSize,
      );
    }

    if (body is Map<String, dynamic>) {
      if (body['success'] == false) {
        throw ServerError(
          body['message']?.toString() ?? AppStrings.errorSomethingWentWrong,
        );
      }

      final data = body.containsKey('data') ? body['data'] : body;

      if (data is List) {
        return _pageFromList(
          data,
          meta: body,
          fallbackPageNumber: fallbackPageNumber,
          fallbackPageSize: fallbackPageSize,
        );
      }

      if (data is Map<String, dynamic>) {
        final rawItems =
            data['items'] ??
            data['products'] ??
            data['results'] ??
            data['data'] ??
            const [];
        return _pageFromList(
          rawItems,
          meta: data,
          fallbackPageNumber: fallbackPageNumber,
          fallbackPageSize: fallbackPageSize,
        );
      }
    }

    throw ServerError(AppStrings.errorUnexpectedResponse);
  }

  ProductsPage _pageFromList(
    dynamic rawItems, {
    required Map<String, dynamic> meta,
    required int fallbackPageNumber,
    required int fallbackPageSize,
  }) {
    final items = _mapList(rawItems);
    final pageNumber = _toInt(meta['pageNumber']) ?? fallbackPageNumber;
    final pageSize = _toInt(meta['pageSize']) ?? fallbackPageSize;
    final totalPages = _toInt(meta['totalPages']);

    return ProductsPage(
      items: items,
      pageNumber: pageNumber,
      pageSize: pageSize,
      totalCount: _toInt(meta['totalCount']) ?? items.length,
      hasNextPage:
          meta['hasNextPage'] == true ||
          (totalPages != null && pageNumber < totalPages) ||
          (totalPages == null && items.length >= pageSize),
    );
  }

  List<ProductModel> _mapList(dynamic json) {
    if (json is! List) return const [];
    return json
        .whereType<Map<String, dynamic>>()
        .map(ProductModel.fromJson)
        .toList(growable: false);
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
