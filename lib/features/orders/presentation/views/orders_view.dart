import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/data_sources/products_remote_data_source.dart';
import 'package:foodloop/features/market/data/repositories/products_repository.dart';
import 'package:foodloop/features/market/presentation/manager/report_product_cubit/report_product_cubit.dart';
import 'package:foodloop/features/market/presentation/views/widgets/report_product_dialog.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';
import 'package:foodloop/features/orders/data/repositories/payment_repository.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_state.dart';
import 'package:foodloop/features/orders/presentation/manager/payment_cubit/payment_cubit.dart';
import 'package:foodloop/features/orders/presentation/manager/payment_cubit/payment_state.dart';
import 'package:foodloop/features/orders/presentation/views/paymob_webview_view.dart';
import 'package:foodloop/features/orders/presentation/views/widgets/payment_method_bottom_sheet.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OrdersCubit()..loadOrders()),
        BlocProvider(
          create: (context) => PaymentCubit(
            PaymentRepository(context.read<ApiManager>()),
          ),
        ),
      ],
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
        body: MultiBlocListener(
          listeners: [
            BlocListener<OrdersCubit, OrdersState>(
              listener: (context, state) {
                if (state is OrderStatusUpdateSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.statusUpdateSuccess,
                        style: const TextStyle(fontFamily: 'DmSans'),
                      ),
                      backgroundColor: AppColors.primaryLight,
                    ),
                  );
                } else if (state is OrderStatusUpdateFail) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.statusUpdateError,
                        style: const TextStyle(fontFamily: 'DmSans'),
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
            BlocListener<PaymentCubit, PaymentState>(
              listener: (context, state) async {
                if (state is PaymentUrlLoaded) {
                  final isSuccess = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaymobWebviewView(paymentUrl: state.checkoutUrl),
                    ),
                  ) as bool?;

                  if (isSuccess == true) {
                    if (context.mounted) {
                      context.read<OrdersCubit>().loadOrders();
                    }
                  }
                } else if (state is PaymentWalletSuccess) {
                  if (context.mounted) {
                    context.read<OrdersCubit>().loadOrders();
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment successful!'),
                      backgroundColor: AppColors.primaryLight,
                    ),
                  );
                } else if (state is PaymentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<PaymentCubit, PaymentState>(
            builder: (context, paymentState) {
              return Stack(
                children: [
                  BlocBuilder<OrdersCubit, OrdersState>(
                    builder: (context, state) {
                      if (state is OrdersLoading || state is OrderStatusUpdateLoading) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }
            if (state is OrdersFail) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.paddingL.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 40.r,
                        color: AppColors.error,
                      ),
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
                        child: Text(
                          AppStrings.retry,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            color: AppColors.primary,
                          ),
                        ),
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
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 72.r,
                          color: AppColors.neutral,
                        ),
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
        if (paymentState is PaymentLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Merchant Action Buttons (Advance + Cancel)
// ─────────────────────────────────────────────────────────────────────────────

class _MerchantOrderActions extends StatelessWidget {
  const _MerchantOrderActions({required this.order});
  final OrderModel order;

  // Status progression — Cancelled and Completed are terminal.
  static const List<String> _progression = [
    'Pending',
    'Confirmed',
    'Preparing',
    'ReadyForPickup',
    'Completed',
  ];

  String? get _nextStatus {
    final idx = _progression.indexWhere(
      (s) => s.toLowerCase() == order.orderStatus.toLowerCase(),
    );
    if (idx == -1 || idx >= _progression.length - 1) return null;
    return _progression[idx + 1];
  }

  bool get _isCancelled => order.orderStatus.toLowerCase() == 'cancelled';
  bool get _isCompleted => order.orderStatus.toLowerCase() == 'completed';

  String _nextStatusLabel(String nextStatus) {
    switch (nextStatus.toLowerCase()) {
      case 'confirmed':
        return AppStrings.orderStatusConfirmed;
      case 'preparing':
        return AppStrings.orderStatusPreparing;
      case 'readyforpickup':
        return AppStrings.orderStatusReadyForPickup;
      case 'completed':
        return AppStrings.orderStatusCompleted;
      default:
        return nextStatus;
    }
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        ),
        title: Text(
          AppStrings.cancelOrderConfirmTitle,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          AppStrings.cancelOrderConfirmMsg,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              ),
            ),
            child: Text(
              AppStrings.keepOrder,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              ),
            ),
            child: Text(
              AppStrings.confirmCancel,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<OrdersCubit>().updateOrderStatus(
        orderId: order.id,
        status: 'Cancelled',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nothing to show for terminal states.
    if (_isCompleted || _isCancelled) return const SizedBox.shrink();

    final next = _nextStatus;

    return Row(
      children: [
        // --- Advance button ---
        if (next != null) ...[
          Expanded(
            child: SizedBox(
              height: 38.h,
              child: ElevatedButton.icon(
                onPressed: () => context.read<OrdersCubit>().updateOrderStatus(
                  orderId: order.id,
                  status: next,
                ),
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16.r,
                  color: AppColors.surface,
                ),
                label: Text(
                  _nextStatusLabel(next),
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.surface,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],

        // --- Cancel button ---
        SizedBox(
          height: 38.h,
          child: OutlinedButton.icon(
            onPressed: () => _confirmCancel(context),
            icon: Icon(Icons.close_rounded, size: 15.r, color: AppColors.error),
            label: Text(
              AppStrings.cancelOrderBtn,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
          ),
        ),
      ],
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
    final isPending = order.orderStatus.toLowerCase() == 'pending';
    final isPaymentPending = order.paymentStatus.toLowerCase() == 'pending';

    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
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
              // Merchant: static chip only (actions are in the buttons below)
              // User: static chip
              _StatusChip(status: order.orderStatus),
            ],
          ),
          SizedBox(height: 10.h),

          // --- Items ---
          ...order.items
              .take(3)
              .map(
                (item) => Padding(
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
                ),
              ),
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
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
          ),
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

          // --- Merchant Action Buttons ---
          if (isMerchant) ...[
            SizedBox(height: 12.h),
            _MerchantOrderActions(order: order),
          ],

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
                icon: Icon(
                  Icons.star_outline_rounded,
                  size: 16.r,
                  color: AppColors.primary,
                ),
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
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusFull.r,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingS.r,
                    vertical: AppConstants.paddingXS.r,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: TextButton.icon(
                onPressed: () => _showReportProductSelection(context, order),
                icon: Icon(
                  Icons.report_problem_outlined,
                  size: 16.r,
                  color: AppColors.error,
                ),
                label: Text(
                  AppStrings.reportProductTitle,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
          ],

          // --- Pay Now Button (user only, pending payment & pending order) ---
          if (!isMerchant && isPending && isPaymentPending) ...[
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => PaymentMethodBottomSheet(totalAmount: order.totalAmount),
                  ).then((selectedMethod) {
                    if (selectedMethod == 'wallet') {
                      context.read<PaymentCubit>().payWithWallet(order.id);
                    } else if (selectedMethod == 'card') {
                      context.read<PaymentCubit>().getCheckoutUrl(order.id);
                    }
                  });
                },
                icon: Icon(
                  Icons.payment_rounded,
                  size: 16.r,
                  color: AppColors.textOnPrimary,
                ),
                label: Text(
                  'Pay Now',
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
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

  void _showReportProductSelection(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingL.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.reportProductTitle,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                ...order.items.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                    title: Text(
                      item.productTitle,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context); // close selection
                      _showReportDialog(context, item.productId);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReportDialog(BuildContext context, String productId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return BlocProvider(
          create: (_) => ReportProductCubit(
            ProductsRepository(
              ProductsRemoteDataSource(context.read<ApiManager>()),
            ),
          ),
          child: ReportProductDialog(productId: productId),
        );
      },
    );
  }
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
