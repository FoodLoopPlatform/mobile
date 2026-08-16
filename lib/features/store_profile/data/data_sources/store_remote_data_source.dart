import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/features/store_profile/data/models/store_details_model.dart';

class StoreRemoteDataSource {
  final ApiManager _apiManager;

  StoreRemoteDataSource(this._apiManager);

  /// Fetches the full store details including recent reviews.
  Future<StoreDetailsModel> getStoreDetails(String storeId) async {
    final response = await _apiManager.get(
      '${ApiConstants.storesEndpoint}/$storeId',
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['data'] != null) {
      return StoreDetailsModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw Exception('Unexpected response format for store details');
  }

  /// Fetches paginated reviews for a store.
  /// Returns a tuple of (reviews, totalPages).
  Future<({List<StoreReviewModel> reviews, int totalPages})> getStoreReviews({
    required String storeId,
    required int pageNumber,
    required int pageSize,
  }) async {
    final response = await _apiManager.get(
      ApiConstants.storeReviewsEndpoint(storeId),
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final list = (data['data'] as List<dynamic>? ?? [])
          .map((e) => StoreReviewModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // Extract pagination metadata if available
      final totalPages =
          (data['totalPages'] as num?)?.toInt() ??
          (data['pagination']?['totalPages'] as num?)?.toInt() ??
          1;

      return (reviews: list, totalPages: totalPages);
    }
    throw Exception('Unexpected response format for store reviews');
  }
}
