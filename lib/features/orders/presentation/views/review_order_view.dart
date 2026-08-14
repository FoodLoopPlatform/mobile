import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:foodloop/features/orders/presentation/views/widgets/review_order_body.dart';

class ReviewOrderView extends StatelessWidget {
  const ReviewOrderView({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20.r,
              color: AppColors.primary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppStrings.appName,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16.w),
              padding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                order.shortId,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: ReviewOrderBody(order: order),
      ),
    );
  }
}
