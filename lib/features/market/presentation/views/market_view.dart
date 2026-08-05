import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/market/presentation/views/widgets/market_body.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 20.w,
        title: Row(
          children: [
            Icon(Icons.eco_rounded, size: 24.r, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              AppStrings.marketBrand,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_rounded,
                size: 24.r, color: AppColors.textSecondary),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: const MarketBody(),
    );
  }
}
