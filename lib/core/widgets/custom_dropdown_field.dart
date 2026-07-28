import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    super.key,
    this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  /// Caps label above the field; when null no label row is rendered.
  final String? label;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.neutralLight),
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            color: AppColors.textPrimary,
          ),
          dropdownColor: AppColors.surface,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textHint,
              fontFamily: 'DmSans',
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
