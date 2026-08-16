import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/presentation/manager/scanning_cubit/scanning_cubit.dart';
import 'package:foodloop/features/add_product/presentation/manager/scanning_cubit/scanning_state.dart';

class ScanningBody extends StatefulWidget {
  const ScanningBody({
    super.key,
    required this.image,
    required this.batches,
    required this.onNavigateToResults,
  });

  final File image;
  final List<ExpirationBatch> batches;

  /// Called when ready to proceed to the results screen.
  /// [updatedBatches] carries OCR-enriched data (or fallback).
  final ValueChanged<List<ExpirationBatch>> onNavigateToResults;

  @override
  State<ScanningBody> createState() => _ScanningBodyState();
}

class _ScanningBodyState extends State<ScanningBody>
    with TickerProviderStateMixin {
  static final List<String> _messages = [
    AppStrings.scanningMessage1,
    AppStrings.scanningMessage2,
    AppStrings.scanningMessage3,
    AppStrings.scanningMessage4,
  ];

  late final AnimationController _scanController;
  late final AnimationController _floatController;

  int _messageIndex = 0;
  int _elapsedSeconds = 0;

  // Timers used for the UI animation only
  late final StreamSubscription<int> _messageTimer;
  late final StreamSubscription<int> _elapsedTimer;

  @override
  void initState() {
    super.initState();

    _messageTimer = Stream.periodic(
      const Duration(milliseconds: 1500),
      (i) => i,
    ).listen((_) {
      if (mounted) {
        setState(() => _messageIndex = (_messageIndex + 1) % _messages.length);
      }
    });

    _elapsedTimer = Stream.periodic(
      const Duration(seconds: 1),
      (i) => i,
    ).listen((_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });


    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Trigger the actual OCR call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScanningCubit>().scanImage(
            image: widget.image,
            batches: widget.batches,
          );
    });
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    _elapsedTimer.cancel();
    _scanController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  // ── Called when OCR succeeds (or graceful fallback with date) ──────────────
  void _proceed(List<ExpirationBatch> updatedBatches) {
    widget.onNavigateToResults(updatedBatches);
  }

  // ── Called when OCR failed AND no date exists — force manual pick ──────────
  Future<void> _showNoDateDialog() async {
    if (!mounted) return;

    DateTime? picked;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          AppStrings.ocrNoDateTitle,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          AppStrings.ocrNoDateMessage,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final now = DateTime.now();
              final chosen = await showDatePicker(
                context: ctx,
                initialDate: now.add(const Duration(days: 7)),
                firstDate: now,
                lastDate: DateTime(now.year + 5),
              );
              if (chosen != null) {
                picked = chosen;
                if (ctx.mounted) Navigator.of(ctx).pop();
              }
            },
            child: Text(
              AppStrings.ocrNoDatePickButton,
              style: const TextStyle(
                fontFamily: 'DmSans',
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );

    if (picked != null && mounted) {
      // Build fallback batches with the manually chosen date
      final fallback = widget.batches.isNotEmpty
          ? widget.batches
              .map((b) => b.copyWith(date: picked, confidenceScore: 0.0))
              .toList()
          : [ExpirationBatch(date: picked!, quantity: 1, confidenceScore: 0.0)];
      _proceed(fallback);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanningCubit, ScanningState>(
      listener: (context, state) {
        if (state is ScanningSuccess) {
          _proceed(state.updatedBatches);
        } else if (state is ScanningErrorWithDate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.ocrScanFailed,
                style: const TextStyle(fontFamily: 'DmSans'),
              ),
              backgroundColor: AppColors.error,
            ),
          );
          _proceed(state.fallbackBatches);
        } else if (state is ScanningErrorNoDate) {
          _showNoDateDialog();
        }
      },
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.screenHorizontalPadding.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // --- Scanner ---
              _Scanner(
                image: widget.image,
                scanController: _scanController,
                floatController: _floatController,
              ),
              SizedBox(height: AppConstants.paddingXL.h),

              Text(
                AppStrings.scanningTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppConstants.paddingS.h),

              // --- Rotating status line ---
              AnimatedSwitcher(
                duration: AppConstants.animationNormal,
                child: SizedBox(
                  key: ValueKey(_messageIndex),
                  height: 44.h,
                  child: Text(
                    _messages[_messageIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppConstants.paddingL.h),

              // --- Live stats ---
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: AppStrings.scanStatusLabel,
                      value: AppStrings.scanStatusAnalyzing,
                      showPulse: true,
                    ),
                  ),
                  SizedBox(width: AppConstants.paddingS.w),
                  Expanded(
                    child: _StatTile(
                      label: AppStrings.scanElapsedLabel,
                      value: '$_elapsedSeconds${AppStrings.scanSecondsSuffix}',
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // --- Footer badge ---
              Container(
                margin: EdgeInsets.only(bottom: AppConstants.paddingL.h),
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM.w,
                  vertical: AppConstants.paddingS.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shield_rounded,
                      size: 16.r,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.scanSecureFooter,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Scanner extends StatelessWidget {
  const _Scanner({
    required this.image,
    required this.scanController,
    required this.floatController,
  });

  final File image;
  final AnimationController scanController;
  final AnimationController floatController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.r,
      height: 200.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // --- Captured photo behind the scan overlay ---
          Container(
            width: 190.r,
            height: 190.r,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
            ),
            child: Opacity(
              opacity: 0.45,
              child: Image.file(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),

          // --- Floating central icon ---
          AnimatedBuilder(
            animation: floatController,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, -10 + (floatController.value * 20)),
              child: child,
            ),
            child: Icon(
              Icons.document_scanner_outlined,
              size: 64.r,
              color: AppColors.primary,
            ),
          ),

          // --- Sweeping beam ---
          AnimatedBuilder(
            animation: scanController,
            builder: (context, child) => Align(
              alignment: Alignment(0, -1 + (scanController.value * 2)),
              child: child,
            ),
            child: Container(
              height: 3.h,
              width: 180.r,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0),
                    AppColors.primaryLight,
                    AppColors.primary.withValues(alpha: 0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryLight.withValues(alpha: 0.6),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    this.showPulse = false,
  });

  final String label;
  final String value;
  final bool showPulse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingS.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              if (showPulse) ...[
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(width: 6.w),
              ],
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
