import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Section heading with an optional trailing "View All" action or inline icon.
class MarketSectionHeader extends StatelessWidget {
  const MarketSectionHeader({
    super.key,
    required this.title,
    this.showViewAll = false,
    this.trailingIcon,
  });

  final String title;
  final bool showViewAll;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.screenHorizontalPadding.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          if (trailingIcon != null) ...[
            SizedBox(width: 6.w),
            Icon(trailingIcon, size: 20.r, color: AppColors.error),
          ],
          const Spacer(),
          if (showViewAll)
            GestureDetector(
              onTap: () {},
              child: Text(
                AppStrings.viewAll,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
