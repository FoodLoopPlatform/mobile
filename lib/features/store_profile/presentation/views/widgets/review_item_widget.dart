import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/features/store_profile/data/models/store_details_model.dart';

class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({super.key, required this.review});

  final StoreReviewModel review;

  @override
  Widget build(BuildContext context) {
    final timeSince = _timeSince(review.createdAt);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          _Avatar(name: review.userFullName),
          SizedBox(width: 12.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.userFullName.isNotEmpty
                          ? review.userFullName
                          : 'Anonymous',
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      timeSince,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 11.sp,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                _StarRow(rating: review.rating),
                SizedBox(height: 6.h),
                Text(
                  review.comment,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _timeSince(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 365) {
      return '${(diff.inDays / 365).floor()}y ago';
    } else if (diff.inDays >= 30) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    }
    return 'Just now';
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySurface,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          Icons.star_rounded,
          size: 14.r,
          color: i < rating
              ? AppColors.onTertiaryContainer
              : AppColors.outlineVariant,
        );
      }),
    );
  }
}
