import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/expiration_date_field.dart';

/// One "date batch": a photo, its own expiry date and a unit count.
class ExpirationBatchTile extends StatelessWidget {
  const ExpirationBatchTile({
    super.key,
    required this.date,
    required this.quantityController,
    required this.photo,
    required this.onPickDate,
    required this.onPickPhoto,
    required this.onDelete,
  });

  final DateTime? date;
  final TextEditingController quantityController;
  final File? photo;
  final VoidCallback onPickDate;
  final VoidCallback onPickPhoto;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingS.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Photo slot ---
          GestureDetector(
            onTap: onPickPhoto,
            child: Container(
              width: 72.r,
              height: 72.r,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              ),
              child: photo == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined,
                            size: 20.r, color: AppColors.textSecondary),
                        SizedBox(height: 4.h),
                        Text(
                          AppStrings.batchUploadPhoto,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    )
                  : Image.file(
                      photo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image_outlined,
                        size: 20.r,
                        color: AppColors.textHint,
                      ),
                    ),
            ),
          ),
          SizedBox(width: AppConstants.paddingS.w),

          // --- Date + quantity ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpirationDateField(
                  label: AppStrings.manualExpiryLabel,
                  date: date,
                  onTap: onPickDate,
                ),
                SizedBox(height: AppConstants.paddingS.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 13.sp,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: AppStrings.quantityShort,
                          labelStyle: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      visualDensity: VisualDensity.compact,
                      icon: Icon(Icons.delete_outline_rounded,
                          size: 20.r, color: AppColors.error),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
