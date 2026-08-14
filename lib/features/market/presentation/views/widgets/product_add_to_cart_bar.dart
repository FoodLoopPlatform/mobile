import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/cart/data/models/cart_item_model.dart';
import 'package:foodloop/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:foodloop/features/cart/presentation/manager/cart_cubit/cart_state.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';

/// Sticky bottom bar: a quantity stepper next to the "Add to Cart" CTA.
/// When the product is already in the cart, the bar switches to a
/// full-width inline stepper (increment / quantity / decrement / remove).
class ProductAddToCartBar extends StatefulWidget {
  const ProductAddToCartBar({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductAddToCartBar> createState() => _ProductAddToCartBarState();
}

class _ProductAddToCartBarState extends State<ProductAddToCartBar> {
  // Local quantity used only when the product is NOT yet in the cart.
  int _localQty = 1;

  void _increment() => setState(() => _localQty++);
  void _decrement() {
    if (_localQty > 1) setState(() => _localQty--);
  }

  /// Returns the current quantity of this product in the cart, or null if
  /// it is not in the cart yet.
  int? _cartQty(CartState state) {
    if (state is! CartLoaded) return null;
    final match = state.items
        .where((i) => i.productId == widget.product.id)
        .toList();
    return match.isEmpty ? null : match.first.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartQty = _cartQty(state);
        final inCart = cartQty != null;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding.w,
                vertical: AppConstants.paddingM.h,
              ),
              child: inCart
                  ? _buildInCartStepper(context, cartQty)
                  : _buildAddToCartRow(context),
            ),
          ),
        );
      },
    );
  }

  // ── Already-in-cart: full-width stepper ────────────────────────────────────

  Widget _buildInCartStepper(BuildContext context, int qty) {
    final cubit = context.read<CartCubit>();
    return SizedBox(
      height: 52.h,
      child: Row(
        children: [
          // Remove button
          _iconBtn(
            icon: Icons.delete_outline_rounded,
            color: AppColors.error,
            onTap: () => cubit.removeItem(widget.product.id),
          ),
          SizedBox(width: AppConstants.paddingS.w),

          // Stepper
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StepButton(
                    icon: Icons.remove_rounded,
                    onTap: () => cubit.updateQuantity(widget.product.id, qty - 1),
                  ),
                  Text(
                    '$qty',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  _StepButton(
                    icon: Icons.add_rounded,
                    onTap: () => cubit.updateQuantity(widget.product.id, qty + 1),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: AppConstants.paddingS.w),

          // "In Cart" label chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_rounded,
                    size: 16.r, color: AppColors.textOnPrimary),
                SizedBox(width: 4.w),
                Text(
                  AppStrings.inCart,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Not in cart: qty picker + Add to Cart CTA ──────────────────────────────

  Widget _buildAddToCartRow(BuildContext context) {
    return Row(
      children: [
        // --- Quantity stepper ---
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Row(
            children: [
              _StepButton(icon: Icons.remove_rounded, onTap: _decrement),
              SizedBox(
                width: 32.w,
                child: Text(
                  '$_localQty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _StepButton(icon: Icons.add_rounded, onTap: _increment),
            ],
          ),
        ),
        SizedBox(width: AppConstants.paddingS.w),

        // --- CTA ---
        Expanded(
          child: SizedBox(
            height: 52.h,
            child: ElevatedButton(
              onPressed: () {
                context.read<CartCubit>().addItem(
                      CartItemModel(
                        productId: widget.product.id,
                        name: widget.product.name,
                        price: widget.product.price,
                        imageUrl: widget.product.imageUrl,
                        quantity: _localQty,
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusM.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_rounded,
                      size: 20.r, color: AppColors.textOnPrimary),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.addToCart,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.r,
        height: 52.r,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 22.r),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 40.w,
        height: 40.h,
        child: Icon(icon, size: 22.r, color: AppColors.primary),
      ),
    );
  }
}
