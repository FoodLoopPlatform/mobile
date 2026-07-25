import 'package:flutter/material.dart';
import 'package:foodloop/core/utils/app_colors.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('Cart View'),
      ),
    );
  }
}
