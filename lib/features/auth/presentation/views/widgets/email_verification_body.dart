import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_outlined_button.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/info_row.dart';

class EmailVerificationBody extends StatefulWidget {
  const EmailVerificationBody({super.key, required this.email});
  final String email;

  @override
  State<EmailVerificationBody> createState() => _EmailVerificationBodyState();
}

class _EmailVerificationBodyState extends State<EmailVerificationBody> {
  late int _remainingSeconds;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = AppConstants.otpExpirySeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _resend() {
    setState(() {
      _remainingSeconds = AppConstants.otpExpirySeconds;
      _canResend = false;
    });
    _timer?.cancel();
    _startTimer();
    // TODO: call cubit.resendVerification(widget.email);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding.w,
          vertical: AppConstants.paddingXL.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Mail Icon ---
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.mark_email_unread_outlined,
                    size: 28.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 28.h),

            // --- Title ---
            Text(
              AppStrings.verificationPendingTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            Text(
              AppStrings.verificationPendingSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            SizedBox(height: 36.h),

            // --- Sent To ---
            InfoRow(
              label: AppStrings.sentToLabel,
              value: widget.email.isNotEmpty
                  ? widget.email
                  : 'm.chen@foodloop.com',
              valueColor: AppColors.primary,
            ),
            SizedBox(height: 20.h),

            // --- Expires In ---
            InfoRow(
              label: AppStrings.expiresInLabel,
              value: _formatTime(_remainingSeconds),
              valueColor: _remainingSeconds < 60
                  ? AppColors.error
                  : AppColors.tertiary,
              isMonospace: true,
            ),
            SizedBox(height: 40.h),

            // --- Check Mailbox Button ---
            CustomButton(
              label: AppStrings.checkMailbox,
              suffixIcon: Icons.open_in_new_rounded,
              onTap: () {
                // TODO: open mail app
              },
            ),
            SizedBox(height: 12.h),

            // --- Resend Email Button ---
            CustomOutlinedButton(
              label: _canResend
                  ? AppStrings.resendEmail
                  : '${AppStrings.resendEmail} (${_formatTime(_remainingSeconds)})',
              onTap: _canResend ? _resend : () {},
            ),
            SizedBox(height: 40.h),

            // --- Footer ---
            GestureDetector(
              onTap: () => Navigator.popUntil(context, (r) => r.isFirst),
              child: Text(
                AppStrings.appName,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
