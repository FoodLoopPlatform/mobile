import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/store_profile/data/models/store_details_model.dart';

class StoreHeaderCard extends StatelessWidget {
  const StoreHeaderCard({super.key, required this.store});

  final StoreDetailsModel store;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Cover photo ──────────────────────────────────────────────────────
        _CoverPhoto(url: store.coverPhoto),

        // ── Bottom white fade + logo + name section ──────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              AppConstants.screenHorizontalPadding.w,
              60.h,
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingM.h,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.0),
                  AppColors.background.withValues(alpha: 0.95),
                  AppColors.background,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 14.r, color: AppColors.outline),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        '${store.city}, ${store.governorate}',
                        style: TextStyle(
                          fontFamily: 'DmSans',
                          fontSize: 13.sp,
                          color: AppColors.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Logo avatar floating over the cover ──────────────────────────────
        Positioned(
          bottom: AppConstants.paddingM.h + 34.h,
          right: AppConstants.screenHorizontalPadding.w,
          child: _LogoAvatar(url: store.logo, name: store.name),
        ),
      ],
    );
  }
}

class _CoverPhoto extends StatelessWidget {
  const _CoverPhoto({required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: url != null && url!.isNotEmpty
          ? Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, e, s) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() => Container(
        color: AppColors.primarySurface,
        child: Center(
          child: Icon(Icons.storefront_rounded,
              size: 48.r, color: AppColors.primary.withValues(alpha: 0.4)),
        ),
      );
}

class _LogoAvatar extends StatelessWidget {
  const _LogoAvatar({required this.url, required this.name});
  final String? url;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: AppColors.surface, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: url != null && url!.isNotEmpty
            ? Image.network(url!, fit: BoxFit.cover,
                errorBuilder: (_, e, s) => _initials())
            : _initials(),
      ),
    );
  }

  Widget _initials() {
    final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      color: AppColors.primarySurface,
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
