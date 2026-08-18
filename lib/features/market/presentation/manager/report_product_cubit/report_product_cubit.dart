import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/features/market/data/repositories/products_repository.dart';
import 'package:foodloop/features/market/presentation/manager/report_product_cubit/report_product_state.dart';

class ReportProductCubit extends Cubit<ReportProductState> {
  final ProductsRepository _repository;

  ReportProductCubit(this._repository) : super(ReportProductInitial());

  Future<void> reportProduct({
    required String productId,
    required String reason,
    required String details,
  }) async {
    emit(ReportProductLoading());
    try {
      await _repository.reportProduct(
        productId: productId,
        reason: reason,
        details: details,
      );
      emit(ReportProductSuccess());
    } catch (e) {
      emit(ReportProductFailure(e.toString()));
    }
  }
}
