import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onUpload,
    this.pickedFileName,
    this.onRemove,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onUpload;
  final String? pickedFileName;
  final VoidCallback? onRemove;

  bool get _isPicked => pickedFileName != null;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: _isPicked ? AppColors.primarySurface : AppColors.surface,
        border: Border.all(
          color: _isPicked ? AppColors.primary : AppColors.border,
          width: _isPicked ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: _isPicked ? AppColors.primary : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  _isPicked ? Icons.check_rounded : icon,
                  size: 18.r,
                  color: _isPicked ? AppColors.surface : AppColors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _isPicked ? pickedFileName! : subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 11.sp,
                        color: _isPicked ? AppColors.primary : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isPicked) ...[
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded, size: 14.r, color: AppColors.error),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: onUpload,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      AppStrings.changeLabel,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ] else
                GestureDetector(
                  onTap: onUpload,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.pendingSurface,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      AppStrings.statusPending,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pending,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
