import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/features/orders/data/repositories/payment_repository.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentCubit(this._paymentRepository) : super(PaymentInitial());

  Future<void> getCheckoutUrl(String orderId) async {
    emit(PaymentLoading());
    try {
      final url = await _paymentRepository.getCheckoutUrl(orderId);
      emit(PaymentUrlLoaded(url));
    } catch (e) {
      if (e is ServerError) {
        emit(PaymentError(e.errMessage));
      } else {
        emit(PaymentError(e.toString()));
      }
    }
  }

  Future<void> payWithWallet(String orderId) async {
    emit(PaymentLoading());
    try {
      await _paymentRepository.walletCheckout(orderId);
      emit(PaymentWalletSuccess());
    } catch (e) {
      if (e is ServerError) {
        emit(PaymentError(e.errMessage));
      } else {
        emit(PaymentError(e.toString()));
      }
    }
  }
}
