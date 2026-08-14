import 'package:flutter/material.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/cart/data/models/order_response_model.dart';
import 'widgets/checkout_success_body.dart';

class CheckoutSuccessView extends StatelessWidget {
  final OrderResponseModel response;

  const CheckoutSuccessView({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          AppStrings.checkout,
          style: const TextStyle(
            fontFamily: 'DmSans',
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.primary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CheckoutSuccessBody(response: response),
    );
  }
}
