import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/enums/account_type_enum.dart';
import 'package:foodloop/core/models/user_model.dart';
import 'package:foodloop/core/utils/secure_storage_helper.dart';
import 'package:foodloop/features/cart/data/models/cart_item_model.dart';
import 'package:foodloop/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';
import 'package:foodloop/features/cart/presentation/manager/cart_cubit/cart_state.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_image.dart';

/// Wide featured card used in the "Recommended for You" carousel.
class RecommendedProductCard extends StatefulWidget {
  const RecommendedProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  State<RecommendedProductCard> createState() => _RecommendedProductCardState();
}

class _RecommendedProductCardState extends State<RecommendedProductCard> {
  bool isCustomer = false;
  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  void _loadRole() async {
    final role = await SecureStorageHelper.getUserRole();
    if (mounted) {
      setState(() {
        isCustomer = role?.toLowerCase() == 'user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 260.w,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image + badge ---
            SizedBox(
              height: 150.h,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ProductImage(imageUrl: widget.product.imageUrl),
                  ),
                  if (widget.product.badge != null)
                    Positioned(
                      top: 12.r,
                      right: 12.r,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusFull.r,
                          ),
                        ),
                        child: Text(
                          widget.product.badge!,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- Details ---
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingM.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.product.seller,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingS.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppStrings.currencyEgp} ${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      // Cart button only for regular customers.
                      if (isCustomer)
                        _RecommendedCartButton(product: widget.product),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Cart button for the recommended card ───────────────────────────────────────

class _RecommendedCartButton extends StatefulWidget {
  const _RecommendedCartButton({required this.product});
  final ProductModel product;

  @override
  State<_RecommendedCartButton> createState() => _RecommendedCartButtonState();
}

class _RecommendedCartButtonState extends State<_RecommendedCartButton> {
  // ── Dialog ─────────────────────────────────────────────────────────────────

  void _showStoreConflictDialog(
    BuildContext context,
    CartItemModel pendingItem,
  ) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.store_mall_directory_rounded,
                color: AppColors.primary,
                size: 22.r,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  AppStrings.cartStoreConflictTitle,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            AppStrings.cartStoreConflictMessage,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                ),
              ),
              child: Text(
                AppStrings.cartStoreConflictCancel,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                ),
              ),
              child: Text(
                AppStrings.cartStoreConflictConfirm,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (!context.mounted) return;
      if (confirmed == true) {
        context.read<CartCubit>().clearCartAndAdd(pendingItem);
      } else {
        context.read<CartCubit>().loadCart();
      }
    });
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listenWhen: (previous, current) {
        if (current is! CartStoreConflict) return false;
        if (current.pendingItem.productId != widget.product.id) return false;

        return ModalRoute.of(context)?.isCurrent == true;
      },
      listener: (context, state) {
        if (state is CartStoreConflict) {
          _showStoreConflictDialog(context, state.pendingItem);
        }
      },
      builder: (context, state) {
        int? cartQty;
        if (state is CartLoaded) {
          final match = state.items
              .where((i) => i.productId == widget.product.id)
              .toList();
          cartQty = match.isEmpty ? null : match.first.quantity;
        }

        if (cartQty != null) {
          return _InlineCartStepper(product: widget.product, quantity: cartQty);
        }

        return GestureDetector(
          onTap: () {
            context.read<CartCubit>().addItem(
              CartItemModel(
                productId: widget.product.id,
                name: widget.product.name,
                price: widget.product.price,
                imageUrl: widget.product.imageUrl,
                quantity: 1,
                organizationId: widget.product.organizationId ?? '',
                storeName: widget.product.seller,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
            ),
            child: Icon(
              Icons.add_shopping_cart_rounded,
              size: 20.r,
              color: AppColors.textOnPrimary,
            ),
          ),
        );
      },
    );
  }
}

/// Compact inline stepper for cards — shows – qty + with animated transitions.
class _InlineCartStepper extends StatelessWidget {
  const _InlineCartStepper({required this.product, required this.quantity});

  final ProductModel product;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return GestureDetector(
      // Prevent the card's onTap from firing when interacting with stepper
      onTap: () {},
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => cubit.updateQuantity(product.id, quantity - 1),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  quantity == 1
                      ? Icons.delete_outline_rounded
                      : Icons.remove_rounded,
                  size: 16.r,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                '$quantity',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => cubit.updateQuantity(product.id, quantity + 1),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.add_rounded,
                  size: 16.r,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
