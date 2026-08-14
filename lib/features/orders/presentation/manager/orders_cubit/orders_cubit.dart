import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRemoteDataSource _dataSource;

  OrdersCubit()
      : _dataSource = OrdersRemoteDataSource(ApiManager()),
        super(const OrdersInitial());

  Future<void> loadOrders() async {
    emit(const OrdersLoading());
    try {
      final orders = await _dataSource.getOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersFail(e.toString()));
    }
  }
}
