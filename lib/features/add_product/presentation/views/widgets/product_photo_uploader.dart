import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Dashed drop-zone for product images. Shows a thumbnail strip once files are
/// chosen; tapping anywhere re-opens the picker.
class ProductPhotoUploader extends StatelessWidget {
  const ProductPhotoUploader({
    super.key,
    required this.photos,
    required this.onPhotosChanged,
  });

  final List<File> photos;
  final ValueChanged<List<File>> onPhotosChanged;

  Future<void> _pickPhotos() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) return;

    final picked = result.paths
        .whereType<String>()
        .map(File.new)
        .toList(growable: false);
    if (picked.isNotEmpty) onPhotosChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickPhotos,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppConstants.paddingL.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
              border: Border.all(
                color: photos.isEmpty
                    ? AppColors.outlineVariant
                    : AppColors.primary,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryContainer,
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    size: 28.r,
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
                SizedBox(height: AppConstants.paddingM.h),
                Text(
                  AppStrings.productPhotosTitle,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  photos.isEmpty
                      ? AppStrings.productPhotosHint
                      : '${photos.length} ${AppStrings.productPhotosSelected}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    fontWeight:
                        photos.isEmpty ? FontWeight.w400 : FontWeight.w700,
                    color: photos.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Thumbnails ---
        if (photos.isNotEmpty) ...[
          SizedBox(height: AppConstants.paddingS.h),
          SizedBox(
            height: 72.r,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                child: Image.file(
                  photos[index],
                  width: 72.r,
                  height: 72.r,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72.r,
                    height: 72.r,
                    color: AppColors.surfaceContainerHigh,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 20.r,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],

        SizedBox(height: AppConstants.paddingS.h),

        // --- Tip ---
        Container(
          padding: EdgeInsets.all(AppConstants.paddingS.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 18.r, color: AppColors.primaryLight),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  AppStrings.productPhotosTip,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
