import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/document_tile.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/section_header.dart';

class BusinessDetailsLegalSection extends StatelessWidget {
  const BusinessDetailsLegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: Icons.description_outlined,
          title: AppStrings.legalDocumentsSectionTitle,
        ),
        SizedBox(height: 16.h),
        DocumentTile(
          icon: Icons.receipt_long_outlined,
          title: AppStrings.taxIdLabel,
          subtitle: AppStrings.taxIdSubtitle,
          onUpload: () {},
        ),
        SizedBox(height: 12.h),
        DocumentTile(
          icon: Icons.business_outlined,
          title: AppStrings.commercialRegLabel,
          subtitle: AppStrings.commercialRegSubtitle,
          onUpload: () {},
        ),
        SizedBox(height: 12.h),
        DocumentTile(
          icon: Icons.health_and_safety_outlined,
          title: AppStrings.healthCertLabel,
          subtitle: AppStrings.healthCertSubtitle,
          onUpload: () {},
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 14.r, color: AppColors.neutral),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  AppStrings.verificationTimeNote,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
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
