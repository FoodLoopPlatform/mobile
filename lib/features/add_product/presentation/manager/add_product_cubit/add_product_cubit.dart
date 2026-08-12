import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/data/repositories/add_product_repository.dart';

import 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final AddProductRepository _repository;

  AddProductCubit(this._repository) : super(AddProductInitial());

  Future<void> publishProducts(ProductDraft draft, List<ExpirationBatch> batches) async {
    emit(AddProductLoading());
    try {
      await _repository.publishProducts(draft: draft, batches: batches);
      emit(AddProductSuccess());
    } on ServerError catch (e) {
      emit(AddProductFail(e.errMessage));
    } catch (e) {
      emit(AddProductFail('An unexpected error occurred.'));
    }
  }

  void resetState() {
    emit(AddProductInitial());
  }
}
