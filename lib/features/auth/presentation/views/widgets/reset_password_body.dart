import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/enums/password_strength_enum.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/auth_brand_footer.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/auth_glow_background.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/reset_password_card.dart';

class ResetPasswordBody extends StatefulWidget {
  const ResetPasswordBody({super.key});

  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  PasswordStrength _strength = PasswordStrength.none;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // --- Ambient corner glows ---
        const Positioned.fill(child: AuthGlowBackground()),

        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenHorizontalPadding.w,
              vertical: AppConstants.paddingXL.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ResetPasswordCard(
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    strength: _strength,
                    onPasswordChanged: (value) => setState(
                      () => _strength = PasswordStrength.fromPassword(value),
                    ),
                    onUpdatePassword: () => _formKey.currentState?.validate(),
                  ),
                  SizedBox(height: AppConstants.paddingL.h),

                  // --- Help line ---
                  const _HelpRow(),
                  SizedBox(height: AppConstants.paddingXXL.h),

                  const AuthBrandFooter(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpRow extends StatelessWidget {
  const _HelpRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          AppStrings.needHelpPrefix,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            AppStrings.contactSupport,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
