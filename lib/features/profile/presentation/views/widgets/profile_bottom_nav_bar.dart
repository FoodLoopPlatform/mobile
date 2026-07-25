import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

class ProfileBottomNavBar extends StatelessWidget {
  const ProfileBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _NavItem(
                icon: Icons.storefront_outlined,
                label: AppStrings.navMarket,
              ),
              _NavItem(
                icon: Icons.receipt_long_outlined,
                label: AppStrings.navOrders,
              ),
              _NavItem(
                icon: Icons.shopping_cart_outlined,
                label: AppStrings.navCart,
                badgeCount: 3,
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: AppStrings.navProfile,
                isActive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.badgeCount,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final Color contentColor =
        isActive ? AppColors.onSecondaryContainer : AppColors.textSecondary;

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconWithBadge(icon: icon, color: contentColor, badgeCount: badgeCount),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            color: contentColor,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: content,
      ),
    );
  }
}

class _IconWithBadge extends StatelessWidget {
  const _IconWithBadge({
    required this.icon,
    required this.color,
    this.badgeCount,
  });

  final IconData icon;
  final Color color;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, size: 24.r, color: color);
    if (badgeCount == null) return iconWidget;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        iconWidget,
        Positioned(
          top: -4.h,
          right: -6.w,
          child: Container(
            width: 16.r,
            height: 16.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$badgeCount',
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
    );
  }
}
