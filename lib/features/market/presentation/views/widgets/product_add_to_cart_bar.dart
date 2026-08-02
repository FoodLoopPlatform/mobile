import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Sticky bottom bar: a quantity stepper next to the "Add to Cart" CTA.
class ProductAddToCartBar extends StatefulWidget {
  const ProductAddToCartBar({super.key});

  @override
  State<ProductAddToCartBar> createState() => _ProductAddToCartBarState();
}

class _ProductAddToCartBarState extends State<ProductAddToCartBar> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
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
          child: Row(
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
                        '$_quantity',
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
                    onPressed: () {},
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
          ),
        ),
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
