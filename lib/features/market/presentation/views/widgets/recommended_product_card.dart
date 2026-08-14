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
import 'package:foodloop/features/market/presentation/views/widgets/product_image.dart';

/// Wide featured card used in the "Recommended for You" carousel.
class RecommendedProductCard extends StatelessWidget {
  const RecommendedProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  Positioned.fill(child: ProductImage(imageUrl: product.imageUrl)),
                  if (product.badge != null)
                    Positioned(
                      top: 12.r,
                      right: 12.r,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusFull.r),
                        ),
                        child: Text(
                          product.badge!,
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
                    product.name,
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
                    product.seller,
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
                        '${AppStrings.currencyEgp} ${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      // Cart button: stepper when in cart, add icon when not
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          int? cartQty;
                          if (state is CartLoaded) {
                            final match = state.items
                                .where((i) => i.productId == product.id)
                                .toList();
                            cartQty = match.isEmpty ? null : match.first.quantity;
                          }

                          if (cartQty != null) {
                            return _InlineCartStepper(
                              product: product,
                              quantity: cartQty,
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              context.read<CartCubit>().addItem(
                                    CartItemModel(
                                      productId: product.id,
                                      name: product.name,
                                      price: product.price,
                                      imageUrl: product.imageUrl,
                                      quantity: 1,
                                    ),
                                  );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusS.r),
                              ),
                              child: Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 20.r,
                                color: AppColors.textOnPrimary,
                              ),
                            ),
                          );
                        },
                      ),
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

/// Compact inline stepper for cards — shows – qty + with animated transitions.
class _InlineCartStepper extends StatelessWidget {
  const _InlineCartStepper({
    required this.product,
    required this.quantity,
  });

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
