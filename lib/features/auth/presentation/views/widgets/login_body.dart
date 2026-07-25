import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/auth_brand_footer.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/auth_dotted_background.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/login_form_card.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/login_pending_banner.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPendingBanner = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Pending verification banner ---
        if (_showPendingBanner)
          LoginPendingBanner(
            onClose: () => setState(() => _showPendingBanner = false),
          ),

        // --- Form over the dotted texture ---
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(child: AuthDottedBackground()),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding.w,
                  vertical: AppConstants.paddingL.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      LoginFormCard(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        onLogin: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Navigate to main navigation view
                            Navigator.pushReplacementNamed(
                              context,
                              RoutesNames.mainNav,
                            );
                          }
                        },
                      ),
                      SizedBox(height: AppConstants.paddingXL.h),
                      const AuthBrandFooter(),
                    ],
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
