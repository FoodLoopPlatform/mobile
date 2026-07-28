import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/profile/data/models/address_model.dart';

/// Segmented Home / Company picker for an address's [AddressType].
class AddressLabelSelector extends StatelessWidget {
  const AddressLabelSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AddressType selected;
  final ValueChanged<AddressType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _LabelCard(
            icon: Icons.home_rounded,
            label: AppStrings.addressHomeTitle,
            isSelected: selected == AddressType.home,
            onTap: () => onChanged(AddressType.home),
          ),
        ),
        SizedBox(width: AppConstants.paddingS.w),
        Expanded(
          child: _LabelCard(
            icon: Icons.corporate_fare_rounded,
            label: AppStrings.addressTypeCompany,
            isSelected: selected == AddressType.company,
            onTap: () => onChanged(AddressType.company),
          ),
        ),
      ],
    );
  }
}

class _LabelCard extends StatelessWidget {
  const _LabelCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color accent =
        isSelected ? AppColors.primary : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        padding: EdgeInsets.symmetric(vertical: AppConstants.paddingM.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primarySurface.withValues(alpha: 0.4)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.r, color: accent),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
