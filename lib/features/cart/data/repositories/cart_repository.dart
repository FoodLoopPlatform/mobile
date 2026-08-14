import 'package:foodloop/core/errors/errors.dart';
import '../data_sources/cart_local_data_source.dart';
import '../data_sources/order_remote_data_source.dart';
import '../models/cart_item_model.dart';
import '../models/order_response_model.dart';

class CartRepository {
  final CartLocalDataSource _localDataSource;
  final OrderRemoteDataSource _remoteDataSource;

  CartRepository(this._localDataSource, this._remoteDataSource);

  List<CartItemModel> getLocalCart() => _localDataSource.loadCart();

  Future<void> saveLocalCart(List<CartItemModel> items) =>
      _localDataSource.saveCart(items);

  Future<void> clearLocalCart() => _localDataSource.clearCart();

  Future<OrderResponseModel> placeOrder(List<CartItemModel> items) async {
    try {
      final response = await _remoteDataSource.createOrder(items);
      await _localDataSource.clearCart();
      return response;
    } on ServerError {
      rethrow;
    }
  }
}
