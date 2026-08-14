import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/utils/secure_storage_helper.dart';
import 'package:foodloop/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRemoteDataSource _dataSource;
  List<OrderModel> _cachedOrders = [];
  bool _isMerchant = false;

  OrdersCubit()
      : _dataSource = OrdersRemoteDataSource(ApiManager()),
        super(const OrdersInitial());

  Future<void> loadOrders() async {
    emit(const OrdersLoading());
    try {
      final role = await SecureStorageHelper.getUserRole();
      _isMerchant = role == 'Merchant';

      final orders = _isMerchant
          ? await _dataSource.getMerchantOrders()
          : await _dataSource.getOrders();

      _cachedOrders = orders;
      emit(OrdersLoaded(orders, isMerchant: _isMerchant));
    } catch (e) {
      emit(OrdersFail(e.toString()));
    }
  }

  Future<void> updateOrderStatus(
      {required String orderId, required String status}) async {
    emit(const OrderStatusUpdateLoading());
    try {
      await _dataSource.updateOrderStatus(orderId: orderId, status: status);
      emit(const OrderStatusUpdateSuccess());
      // Refresh the list to reflect the new status
      await loadOrders();
    } catch (e) {
      emit(OrderStatusUpdateFail(e.toString()));
      // Restore loaded state so the UI doesn't get stuck
      emit(OrdersLoaded(_cachedOrders, isMerchant: _isMerchant));
    }
  }

  Future<void> submitReview({
    required String orderId,
    required int rating,
    required String comment,
  }) async {
    emit(const OrderReviewLoading());
    try {
      await _dataSource.submitReview(
          orderId: orderId, rating: rating, comment: comment);
      emit(const OrderReviewSuccess());
    } catch (e) {
      emit(OrderReviewFail(e.toString()));
    }
  }
}
