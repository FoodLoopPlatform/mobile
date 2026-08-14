import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_state.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_cubit.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_state.dart';

class CreateTicketBody extends StatefulWidget {
  const CreateTicketBody({super.key});

  @override
  State<CreateTicketBody> createState() => _CreateTicketBodyState();
}

class _CreateTicketBodyState extends State<CreateTicketBody> {
  final _descriptionController = TextEditingController();
  final _descriptionFocus = FocusNode();
  String? _selectedCategory;

  static const List<String> _categoryValues = [
    'Order Issue',
    'Payment Issue',
    'Delivery Issue',
    'Product Quality',
    'Account Issue',
    'Other',
  ];

  List<String> get _categoryLabels => [
        AppStrings.ticketCategoryOrderIssue,
        AppStrings.ticketCategoryPayment,
        AppStrings.ticketCategoryDelivery,
        AppStrings.ticketCategoryProductQuality,
        AppStrings.ticketCategoryAccount,
        AppStrings.ticketCategoryOther,
      ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.ticketCategoryHint,
            style: const TextStyle(fontFamily: 'DmSans'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.fieldRequired,
            style: const TextStyle(fontFamily: 'DmSans'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    context.read<SupportCubit>().createTicket(
          category: _selectedCategory!,
          message: _descriptionController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SupportCubit, SupportState>(
      listener: (context, state) {
        if (state is SupportCreateTicketSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.ticketCreatedSuccess,
                style: const TextStyle(fontFamily: 'DmSans'),
              ),
              backgroundColor: AppColors.primaryLight,
            ),
          );
          Navigator.pop(context);
        } else if (state is SupportCreateTicketFail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.ticketCreateError,
                style: const TextStyle(fontFamily: 'DmSans'),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppConstants.screenHorizontalPadding.w,
          AppConstants.paddingM.h,
          AppConstants.screenHorizontalPadding.w,
          AppConstants.paddingXXL.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header subtitle
            Text(
              AppStrings.createTicketSubtitle,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppConstants.paddingL.h),

            // --- Category Dropdown ---
            _SectionLabel(label: AppStrings.ticketCategoryLabel),
            SizedBox(height: AppConstants.paddingS.h),
            _CategoryDropdown(
              selectedValue: _selectedCategory,
              labels: _categoryLabels,
              values: _categoryValues,
              onChanged: (val) => setState(() => _selectedCategory = val),
            ),
            SizedBox(height: AppConstants.paddingL.h),

            // --- Recent Orders ---
            _SectionLabel(label: AppStrings.recentOrdersLabel),
            SizedBox(height: AppConstants.paddingS.h),
            _RecentOrdersList(),
            SizedBox(height: AppConstants.paddingL.h),

            // --- Description ---
            _SectionLabel(label: AppStrings.ticketDescriptionLabel),
            SizedBox(height: AppConstants.paddingS.h),
            _DescriptionField(
              controller: _descriptionController,
              focusNode: _descriptionFocus,
            ),
            SizedBox(height: AppConstants.paddingXL.h),

            // --- Submit Button ---
            BlocBuilder<SupportCubit, SupportState>(
              builder: (context, state) {
                final isLoading = state is SupportCreateTicketLoading;
                return _SubmitButton(
                  isLoading: isLoading,
                  onPressed: () => _submit(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontFamily: 'DmSans',
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.outline,
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.selectedValue,
    required this.labels,
    required this.values,
    required this.onChanged,
  });

  final String? selectedValue;
  final List<String> labels;
  final List<String> values;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          hint: Text(
            AppStrings.ticketCategoryHint,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 14.sp,
              color: AppColors.outline,
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary, size: 22.r),
          dropdownColor: AppColors.surface,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          items: List.generate(values.length, (i) {
            return DropdownMenuItem<String>(
              value: values[i],
              child: Text(labels[i]),
            );
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _RecentOrdersList extends StatelessWidget {
  const _RecentOrdersList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrdersFail || state is OrdersInitial) {
          return SizedBox(
            height: 60.h,
            child: Center(
              child: Text(
                AppStrings.ordersLoadingError,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }
        final orders = (state as OrdersLoaded).orders;
        if (orders.isEmpty) {
          return SizedBox(
            height: 60.h,
            child: Center(
              child: Text(
                AppStrings.ordersEmptyTitle,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            children: List.generate(orders.length, (i) {
              return _OrderListItem(
                order: orders[i],
                isLast: i == orders.length - 1,
              );
            }),
          ),
        );
      },
    );
  }
}

class _OrderListItem extends StatelessWidget {
  const _OrderListItem({required this.order, required this.isLast});
  final OrderModel order;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final items = order.items
        .take(2)
        .map((e) => e.productTitle)
        .join(' · ');
    final dateStr =
        '${order.createdAt.day} / ${order.createdAt.month} / ${order.createdAt.year}';
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 14.w, vertical: AppConstants.paddingM.h),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                  size: 22.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shortId,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      items.isNotEmpty ? items : '–',
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                dateStr,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 11.sp,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
            indent: 70.w,
          ),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField(
      {required this.controller, required this.focusNode});
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: 6,
        minLines: 5,
        style: TextStyle(
          fontFamily: 'DmSans',
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: AppStrings.ticketDescriptionHint,
          hintStyle: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            color: AppColors.outline,
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.isLoading, required this.onPressed});
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.submitTicket,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.send_rounded,
                      size: 18.r, color: AppColors.textOnPrimary),
                ],
              ),
      ),
    );
  }
}
