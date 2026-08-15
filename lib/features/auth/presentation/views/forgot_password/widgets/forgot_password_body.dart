import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:foodloop/features/auth/presentation/widgets/auth_brand_footer.dart';
import 'package:foodloop/features/auth/presentation/widgets/auth_glow_background.dart';
import 'package:foodloop/features/auth/presentation/views/forgot_password/widgets/forgot_password_card.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthForgotPasswordSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                  Navigator.pop(context); // Automatically go back to login
                } else if (state is AuthFail) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ForgotPasswordCard(
                        emailController: _emailController,
                        isLoading: state is AuthLoading,
                        onSendResetLink: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<AuthCubit>().forgotPassword(
                                  _emailController.text.trim(),
                                );
                          }
                        },
                      ),
                      SizedBox(height: AppConstants.paddingXXL.h),
                      const AuthBrandFooter(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
