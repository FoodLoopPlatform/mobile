import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_state.dart';

class ReviewOrderBody extends StatefulWidget {
  const ReviewOrderBody({super.key, required this.order});
  final OrderModel order;

  @override
  State<ReviewOrderBody> createState() => _ReviewOrderBodyState();
}

class _ReviewOrderBodyState extends State<ReviewOrderBody> {
  int _rating = 0;
  final _commentController = TextEditingController();
  final _commentFocus = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.reviewRateLabel,
            style: const TextStyle(fontFamily: 'DmSans'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    context.read<OrdersCubit>().submitReview(
          orderId: widget.order.id,
          rating: _rating,
          comment: _commentController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderReviewSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.reviewSuccess,
                style: const TextStyle(fontFamily: 'DmSans'),
              ),
              backgroundColor: AppColors.primaryLight,
            ),
          );
          Navigator.pop(context);
        } else if (state is OrderReviewFail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.reviewError,
                style: const TextStyle(fontFamily: 'DmSans'),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Hero image (shown only if imageUrl present) ---
            if (widget.order.firstItemImageUrl != null)
              _HeroImage(imageUrl: widget.order.firstItemImageUrl!,
                  firstItemName: widget.order.items.isNotEmpty
                      ? widget.order.items.first.productTitle
                      : '')
            else
              _HeroPlaceholder(
                firstItemName: widget.order.items.isNotEmpty
                    ? widget.order.items.first.productTitle
                    : '',
              ),

            // --- Main review card ---
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppConstants.screenHorizontalPadding.w,
                AppConstants.paddingL.h,
                AppConstants.screenHorizontalPadding.w,
                AppConstants.paddingXXL.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    AppStrings.reviewTitle,
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppStrings.reviewSubtitle,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingL.h),

                  // --- Rating & Comment Card ---
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppConstants.paddingL.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusL.r),
                      border: Border.all(
                          color: AppColors.outlineVariant
                              .withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stars
                        Center(
                          child: Column(
                            children: [
                              Text(
                                AppStrings.reviewRateLabel.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'DmSans',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: AppColors.outline,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              _StarRating(
                                rating: _rating,
                                onRatingChanged: (r) =>
                                    setState(() => _rating = r),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppConstants.paddingL.h),
                        Divider(
                            height: 1,
                            color: AppColors.outlineVariant
                                .withValues(alpha: 0.4)),
                        SizedBox(height: AppConstants.paddingL.h),

                        // Comment
                        Text(
                          AppStrings.reviewCommentLabel,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusM.r),
                            border: Border.all(
                                color: AppColors.outlineVariant),
                          ),
                          child: TextField(
                            controller: _commentController,
                            focusNode: _commentFocus,
                            maxLines: 5,
                            minLines: 4,
                            style: TextStyle(
                              fontFamily: 'DmSans',
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: AppStrings.reviewCommentHint,
                              hintStyle: TextStyle(
                                fontFamily: 'DmSans',
                                fontSize: 13.sp,
                                color: AppColors.outline,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 12.h),
                            ),
                          ),
                        ),
                        SizedBox(height: AppConstants.paddingL.h),

                        // Submit Button
                        BlocBuilder<OrdersCubit, OrdersState>(
                          builder: (context, state) {
                            final isLoading = state is OrderReviewLoading;
                            return SizedBox(
                              width: double.infinity,
                              height: AppConstants.buttonHeight.h,
                              child: ElevatedButton(
                                onPressed:
                                    isLoading ? null : () => _submit(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  disabledBackgroundColor:
                                      AppColors.primary.withValues(alpha: 0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusFull.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        AppStrings.reviewSubmit,
                                        style: TextStyle(
                                          fontFamily: 'DmSans',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Star Rating Widget
// ─────────────────────────────────────────────────────────────────────────────

class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, required this.onRatingChanged});
  final int rating;
  final ValueChanged<int> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final starIndex = i + 1;
        return GestureDetector(
          onTap: () => onRatingChanged(starIndex),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                starIndex <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
                key: ValueKey('$starIndex-${starIndex <= rating}'),
                size: 38.r,
                color: starIndex <= rating
                    ? const Color(0xFFFFB800)
                    : AppColors.neutral,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Image (if URL available)
// ─────────────────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl, required this.firstItemName});
  final String imageUrl;
  final String firstItemName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 220.h,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.primarySurface,
              child: Icon(Icons.image_not_supported_outlined,
                  size: 48.r, color: AppColors.primary),
            ),
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.55),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        // Caption
        Positioned(
          bottom: 16.h,
          left: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.yourRecentOrder.toUpperCase(),
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                firstItemName,
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Placeholder (if no image)
// ─────────────────────────────────────────────────────────────────────────────

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder({required this.firstItemName});
  final String firstItemName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 20.h),
      color: AppColors.primarySurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.yourRecentOrder.toUpperCase(),
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            firstItemName.isNotEmpty ? firstItemName : '–',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
