import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:foodloop/features/auth/presentation/widgets/auth_brand_footer.dart';
import 'package:foodloop/features/auth/presentation/widgets/auth_dotted_background.dart';
import 'package:foodloop/features/auth/presentation/views/login/widgets/login_form_card.dart';
import 'package:foodloop/features/auth/presentation/widgets/auth_error_banner.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _errorMessage == message) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesNames.mainNav,
            (route) => false,
          );
        } else if (state is AuthFail) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Column(
          children: [
            // --- Error banner ---
            if (_errorMessage != null)
              AuthErrorBanner(
                message: _errorMessage!,
                onClose: () => setState(() => _errorMessage = null),
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
                            isLoading: isLoading,
                            onLogin: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<AuthCubit>().login(
                                  _emailController.text.trim(),
                                  _passwordController.text,
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
      },
    );
  }
}
