import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Section heading with an underline divider, matching the card headers in the
/// profile design. An optional [trailing] widget sits on the right of the title.
class ProfileSectionTitle extends StatelessWidget {
  const ProfileSectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            ?trailing,
          ],
        ),
        SizedBox(height: AppConstants.paddingS.h),
        const Divider(color: AppColors.outlineVariant, height: 1),
      ],
    );
  }
}
