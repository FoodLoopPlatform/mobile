import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
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
        body: BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrderStatusUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppStrings.statusUpdateSuccess,
                      style: const TextStyle(fontFamily: 'DmSans')),
                  backgroundColor: AppColors.primaryLight,
                ),
              );
            } else if (state is OrderStatusUpdateFail) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppStrings.statusUpdateError,
                      style: const TextStyle(fontFamily: 'DmSans')),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrdersLoading || state is OrderStatusUpdateLoading) {
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
                  itemBuilder: (context, i) => _OrderCard(
                    order: state.orders[i],
                    isMerchant: state.isMerchant,
                  ),
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

// ─────────────────────────────────────────────────────────────────────────────
// Order Card
// ─────────────────────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.isMerchant});
  final OrderModel order;
  final bool isMerchant;

  static const List<String> _statusValues = [
    'Pending',
    'Confirmed',
    'Preparing',
    'ReadyForPickup',
    'Completed',
    'Cancelled',
  ];

  List<String> get _statusLabels => [
        AppStrings.orderStatusPending,
        AppStrings.orderStatusConfirmed,
        AppStrings.orderStatusPreparing,
        AppStrings.orderStatusReadyForPickup,
        AppStrings.orderStatusCompleted,
        AppStrings.orderStatusCancelled,
      ];

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.orderStatus.toLowerCase() == 'completed';

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
          // --- Header Row ---
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
              // Merchant: dropdown to change status | User: static chip
              if (isMerchant)
                _StatusDropdown(
                  currentStatus: order.orderStatus,
                  statusValues: _statusValues,
                  statusLabels: _statusLabels,
                  onChanged: (newStatus) {
                    context.read<OrdersCubit>().updateOrderStatus(
                          orderId: order.id,
                          status: newStatus,
                        );
                  },
                )
              else
                _StatusChip(status: order.orderStatus),
            ],
          ),
          SizedBox(height: 10.h),

          // --- Items ---
          ...order.items.take(3).map((item) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 5.r, color: AppColors.primary),
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

          // --- Footer ---
          Row(
            children: [
              Text(
                _formatDate(order.createdAt),
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

          // --- Review Button (user only, completed orders) ---
          if (!isMerchant && isCompleted) ...[
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  RoutesNames.reviewOrderView,
                  arguments: order,
                ),
                icon: Icon(Icons.star_outline_rounded,
                    size: 16.r, color: AppColors.primary),
                label: Text(
                  AppStrings.leaveReview,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull.r),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Merchant Status Dropdown
// ─────────────────────────────────────────────────────────────────────────────

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({
    required this.currentStatus,
    required this.statusValues,
    required this.statusLabels,
    required this.onChanged,
  });

  final String currentStatus;
  final List<String> statusValues;
  final List<String> statusLabels;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    // Find the matching current value (case-insensitive)
    final matchedValue = statusValues.firstWhere(
      (v) => v.toLowerCase() == currentStatus.toLowerCase(),
      orElse: () => statusValues.first,
    );
    final matchedLabel =
        statusLabels[statusValues.indexOf(matchedValue)];

    final config = _statusConfig(matchedValue);

    return GestureDetector(
      onTap: () async {
        final result = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            MediaQuery.of(context).size.width - 180.w,
            kToolbarHeight,
            16.w,
            0,
          ),
          items: List.generate(statusValues.length, (i) {
            return PopupMenuItem<String>(
              value: statusValues[i],
              child: Text(
                statusLabels[i],
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }),
        );
        if (result != null && result != matchedValue) {
          onChanged(result);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: config.bg,
          borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
          border: Border.all(color: config.text.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              matchedLabel,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: config.text,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.expand_more_rounded,
                size: 14.r, color: config.text),
          ],
        ),
      ),
    );
  }

  _StatusColors _statusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return _StatusColors(
            bg: const Color(0xFFFFF3E0), text: const Color(0xFFE65100));
      case 'confirmed':
        return _StatusColors(
            bg: const Color(0xFFE3F2FD), text: const Color(0xFF1565C0));
      case 'preparing':
        return _StatusColors(
            bg: const Color(0xFFF3E5F5), text: const Color(0xFF6A1B9A));
      case 'readyforpickup':
        return _StatusColors(
            bg: const Color(0xFFE0F7FA), text: const Color(0xFF00695C));
      case 'completed':
        return _StatusColors(
            bg: const Color(0xFFE8F5E9), text: const Color(0xFF2E7D32));
      case 'cancelled':
        return _StatusColors(
            bg: const Color(0xFFFFEBEE), text: const Color(0xFFB71C1C));
      default:
        return _StatusColors(
            bg: const Color(0xFFEEEEEE), text: const Color(0xFF616161));
    }
  }
}

class _StatusColors {
  final Color bg;
  final Color text;
  const _StatusColors({required this.bg, required this.text});
}

// ─────────────────────────────────────────────────────────────────────────────
// Static Status Chip (user view)
// ─────────────────────────────────────────────────────────────────────────────

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
      case 'confirmed':
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        label = AppStrings.orderStatusConfirmed;
        break;
      case 'preparing':
        bgColor = const Color(0xFFF3E5F5);
        textColor = const Color(0xFF6A1B9A);
        label = AppStrings.orderStatusPreparing;
        break;
      case 'readyforpickup':
        bgColor = const Color(0xFFE0F7FA);
        textColor = const Color(0xFF00695C);
        label = AppStrings.orderStatusReadyForPickup;
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
        bgColor = const Color(0xFFEEEEEE);
        textColor = const Color(0xFF616161);
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
