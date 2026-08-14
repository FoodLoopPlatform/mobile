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
}
