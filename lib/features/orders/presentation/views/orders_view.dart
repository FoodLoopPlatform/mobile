import 'package:flutter/material.dart';
import 'package:foodloop/core/utils/app_colors.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('Orders View'),
      ),
    );
  }
}
