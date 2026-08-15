import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_assets.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/profile/data/models/profile_model.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_card.dart';

class ProfilePersonalInfoCard extends StatelessWidget {
  const ProfilePersonalInfoCard({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      clipContents: true,
      child: Stack(
        children: [
          // --- Decorative eco leaf ---
          Positioned(
            bottom: -24.r,
            right: -24.r,
            child: Icon(
              Icons.eco_rounded,
              size: 120.r,
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Avatar + Edit ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileAvatar(imageUrl: profile.profileImage),
                  const Spacer(),
                  const _EditButton(),
                ],
              ),
              SizedBox(height: AppConstants.paddingM.h),

              // --- Name ---
              Text(
                profile.fullName,
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8.h),

              // --- Email ---
              _ContactRow(
                icon: Icons.mail_outline_rounded,
                text: profile.email,
              ),
              SizedBox(height: 8.h),

              // --- Phone (monospace) ---
              _ContactRow(
                icon: Icons.call_outlined,
                text: profile.phoneNumber.isNotEmpty ? profile.phoneNumber : '—',
                isMonospace: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasRemoteImage = imageUrl != null && imageUrl!.isNotEmpty;
    return Container(
      width: 80.r,
      height: 80.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySurface,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 2,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasRemoteImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.person_rounded,
                size: 40.r,
                color: AppColors.primary,
              ),
            )
          : Icon(
              Icons.person_rounded,
              size: 40.r,
              color: AppColors.primary,
            ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, size: 18.r, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              AppStrings.profileEdit,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.text,
    this.isMonospace = false,
  });

  final IconData icon;
  final String text;
  final bool isMonospace;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.textSecondary),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontFamily: isMonospace ? 'JetBrainsMono' : 'DmSans',
            fontSize: 14.sp,
            fontWeight: isMonospace ? FontWeight.w500 : FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
