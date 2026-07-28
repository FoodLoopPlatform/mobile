import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Static map placeholder with a centered pin, a "my location" action and a
/// helper caption. Swap the grid for a real map widget when wiring up geo.
class AddAddressMapSection extends StatelessWidget {
  const AddAddressMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.6,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Stack(
              children: [
                // --- Map-like grid ---
                const Positioned.fill(
                  child: CustomPaint(painter: _MapGridPainter()),
                ),

                // --- Center pin ---
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 44.r,
                        color: AppColors.primary,
                      ),
                      Container(
                        width: 8.w,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusFull.r),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- My-location action ---
                Positioned(
                  bottom: 12.r,
                  right: 12.r,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusM.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.my_location_rounded,
                        size: 20.r, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppConstants.paddingS.h),
        Row(
          children: [
            Icon(Icons.info_outline_rounded,
                size: 18.r, color: AppColors.primaryLight),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                AppStrings.mapDragHint,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter();

  static const double _spacing = 22.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += _spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += _spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
