import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';

class OrdersRemoteDataSource {
  final ApiManager _apiManager;

  OrdersRemoteDataSource(this._apiManager);

  Future<List<OrderModel>> getOrders() async {
    final response = await _apiManager.get(ApiConstants.ordersEndpoint);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<OrderModel>> getMerchantOrders() async {
    final response = await _apiManager.get(ApiConstants.storeOrdersEndpoint);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> submitReview({
    required String orderId,
    required int rating,
    required String comment,
  }) async {
    await _apiManager.post(ApiConstants.reviewsEndpoint, {
      'orderId': orderId,
      'rating': rating,
      'comment': comment,
    });
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    await _apiManager.patch(ApiConstants.storeOrderStatusEndpoint(orderId),
        data: {'status': status});
  }

  Future<void> walletCheckout(String orderId) async {
    await _apiManager.post(ApiConstants.walletCheckoutEndpoint(orderId), {});
  }
}

