import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/cart/data/models/cart_item_model.dart';
import 'package:foodloop/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:foodloop/features/cart/presentation/manager/cart_cubit/cart_state.dart';
import 'package:foodloop/features/cart/presentation/views/checkout_success_view.dart';

class CartBody extends StatefulWidget {
  const CartBody({super.key});

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  bool _isDelivery = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartOrderSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CheckoutSuccessView(response: state.response),
            ),
          );
        } else if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is CartLoaded && state.items.isEmpty) {
          return _buildEmptyCart(context);
        }

        if (state is CartLoaded) {
          return _buildCheckout(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80.r, color: AppColors.neutralLight),
          SizedBox(height: 16.h),
          Text(
            AppStrings.cartEmpty,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.cartEmptySubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 14.sp,
              color: AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }

  // ── Full checkout UI ───────────────────────────────────────────────────────

  Widget _buildCheckout(BuildContext context, CartLoaded state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // ── Fulfillment toggle ────────────────────────────────────
                _buildSectionLabel(AppStrings.fulfillment),
                SizedBox(height: 12.h),
                _buildFulfillmentToggle(),
                SizedBox(height: 16.h),

                // ── Address card ──────────────────────────────────────────
                if (_isDelivery) ...[
                  _buildAddressCard(),
                  SizedBox(height: 24.h),
                ],

                // ── Order Review header ───────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.orderReview,
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${state.items.fold(0, (s, i) => s + i.quantity)} ${AppStrings.items.toUpperCase()}',
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 12.sp,
                        color: AppColors.neutral,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),

        // ── Items list ───────────────────────────────────────────────────
        SliverList.separated(
          itemCount: state.items.length,
          separatorBuilder: (ctx, i) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final item = state.items[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding.w),
              child: _CartItemTile(item: item),
            );
          },
        ),

        // ── Summary card ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenHorizontalPadding.w)
                .copyWith(top: 24.h, bottom: 16.h),
            child: _buildSummaryCard(state),
          ),
        ),

        // ── Place Order button ────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppConstants.screenHorizontalPadding.w,
              0,
              AppConstants.screenHorizontalPadding.w,
              32.h,
            ),
            child: _buildPlaceOrderButton(context),
          ),
        ),
      ],
    );
  }

  // ── Sub-widgets ────────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFulfillmentToggle() {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildToggleOption(
              label: AppStrings.delivery,
              selected: _isDelivery,
              onTap: () => setState(() => _isDelivery = true)),
          _buildToggleOption(
              label: AppStrings.pickup,
              selected: !_isDelivery,
              onTap: () => setState(() => _isDelivery = false)),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.animationFast,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.textOnPrimary : AppColors.neutral,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined,
              color: AppColors.primary, size: 20.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.shippingTo,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10.sp,
                    color: AppColors.neutral,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Home: Maadi, Road 9...',
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Building 42, Apartment 4',
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    color: AppColors.neutral,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              AppStrings.change,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(CartLoaded state) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.summary,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildSummaryRow(
            '${AppStrings.subtotal} (${state.items.fold(0, (s, i) => s + i.quantity)} ${AppStrings.items.toLowerCase()})',
            'EGP ${state.subtotal.toStringAsFixed(2)}',
          ),
          SizedBox(height: 8.h),
          _buildSummaryRow(
            AppStrings.deliveryFee,
            'EGP ${state.deliveryFee.toStringAsFixed(2)}',
          ),
          if (state.discount > 0) ...[
            SizedBox(height: 8.h),
            _buildSummaryRow(
              AppStrings.promoDiscount,
              '- EGP ${state.discount.toStringAsFixed(2)}',
              valueColor: AppColors.success,
            ),
          ],
          SizedBox(height: 12.h),
          Divider(color: AppColors.border, thickness: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.grandTotal,
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'EGP ${state.grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 18.sp,
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

  Widget _buildSummaryRow(String label, String value,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight.h,
      child: ElevatedButton(
        onPressed: () => context.read<CartCubit>().placeOrder(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.placeOrder,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textOnPrimary,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward, size: 18.r),
          ],
        ),
      ),
    );
  }
}

// ── Cart item tile ─────────────────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingS.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            child: item.imageUrl.isNotEmpty
                ? Image.network(
                    item.imageUrl,
                    width: 72.r,
                    height: 72.r,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => _placeholderImage(),
                  )
                : _placeholderImage(),
          ),
          SizedBox(width: 12.w),

          // Name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'EGP ${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Quantity stepper
          _QuantityStepper(item: item),
          SizedBox(width: 4.w),

          // Delete icon
          GestureDetector(
            onTap: () =>
                context.read<CartCubit>().removeItem(item.productId),
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingXS.r),
              child: Icon(Icons.delete_outline,
                  color: AppColors.neutral, size: 20.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 72.r,
      height: 72.r,
      color: AppColors.surfaceContainerHigh,
      child: Icon(Icons.image_not_supported_outlined,
          color: AppColors.neutralLight, size: 28.r),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final CartItemModel item;
  const _QuantityStepper({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onTap: () => context
                .read<CartCubit>()
                .updateQuantity(item.productId, item.quantity - 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              '${item.quantity}',
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onTap: () => context
                .read<CartCubit>()
                .updateQuantity(item.productId, item.quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 16.r, color: AppColors.textPrimary),
      ),
    );
  }
}
