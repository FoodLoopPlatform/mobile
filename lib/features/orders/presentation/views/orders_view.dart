import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_state.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit()..loadOrders(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.ordersTitle,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrdersFail) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.paddingL.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 40.r, color: AppColors.error),
                      SizedBox(height: 12.h),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'DmSans',
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () =>
                            context.read<OrdersCubit>().loadOrders(),
                        child: Text(AppStrings.retry,
                            style: TextStyle(
                                fontFamily: 'DmSans',
                                color: AppColors.primary)),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstants.paddingL.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 72.r, color: AppColors.neutral),
                        SizedBox(height: 16.h),
                        Text(
                          AppStrings.ordersEmptyTitle,
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppStrings.ordersEmptySubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<OrdersCubit>().loadOrders(),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenHorizontalPadding.w,
                    vertical: AppConstants.paddingM.h,
                  ),
                  itemCount: state.orders.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, i) =>
                      _OrderCard(order: state.orders[i]),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border:
            Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Text(
                order.shortId,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              _StatusChip(status: order.orderStatus),
            ],
          ),
          SizedBox(height: 10.h),
          // Items
          ...order.items.take(3).map((item) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    Icon(Icons.circle,
                        size: 5.r, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        item.productTitle,
                        style: TextStyle(
                          fontFamily: 'DmSans',
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'x${item.quantity}',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12.sp,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              )),
          if (order.items.length > 3)
            Text(
              '+ ${order.items.length - 3} ${AppStrings.items}',
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                color: AppColors.outline,
              ),
            ),
          SizedBox(height: 10.h),
          Divider(
              height: 1,
              color: AppColors.outlineVariant.withValues(alpha: 0.4)),
          SizedBox(height: 10.h),
          // Footer
          Row(
            children: [
              Text(
                '${_formatDate(order.createdAt)}',
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 11.sp,
                  color: AppColors.outline,
                ),
              ),
              const Spacer(),
              Text(
                AppStrings.orderTotalLabel,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '${order.totalAmount.toStringAsFixed(0)} ${AppStrings.currencyEgp}',
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFE65100);
        label = AppStrings.orderStatusPending;
        break;
      case 'completed':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        label = AppStrings.orderStatusCompleted;
        break;
      case 'cancelled':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFB71C1C);
        label = AppStrings.orderStatusCancelled;
        break;
      default:
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'DmSans',
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
