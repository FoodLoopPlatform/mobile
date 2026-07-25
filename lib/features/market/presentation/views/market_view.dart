import 'package:flutter/material.dart';
import 'package:foodloop/core/utils/app_colors.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text('Market View'),
      ),
    );
  }
}
