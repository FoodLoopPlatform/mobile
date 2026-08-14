import 'package:dio/dio.dart';
import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/errors/errors.dart';
import '../models/cart_item_model.dart';
import '../models/order_response_model.dart';

class OrderRemoteDataSource {
  final ApiManager _apiManager;

  OrderRemoteDataSource(this._apiManager);

  Future<OrderResponseModel> createOrder(List<CartItemModel> items) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.ordersEndpoint,
        {
          'items': items
              .map((item) => {
                    'productId': item.productId,
                    'quantity': item.quantity,
                  })
              .toList(),
        },
      );
      return OrderResponseModel.fromMap(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is ServerError) rethrow;
      throw ServerError(e.toString());
    }
  }
}
