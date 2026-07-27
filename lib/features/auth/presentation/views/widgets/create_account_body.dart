import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/enums/account_type_enum.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_dropdown_field.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/auth_error_banner.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/create_account_footer.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/create_account_form_fields.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/create_account_header.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/create_account_terms_section.dart';

class CreateAccountBody extends StatefulWidget {
  const CreateAccountBody({super.key});

  @override
  State<CreateAccountBody> createState() => _CreateAccountBodyState();
}

class _CreateAccountBodyState extends State<CreateAccountBody> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreedToTerms = false;
  AccountType _selectedAccountType = AccountType.user;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 8) return AppStrings.passwordStrengthWeak;
    if (password.length < 12) return AppStrings.passwordStrengthFair;
    return AppStrings.passwordStrengthStrong;
  }

  Color _getPasswordStrengthColor(String strength) {
    switch (strength) {
      case AppStrings.passwordStrengthWeak:
        return AppColors.error;
      case AppStrings.passwordStrengthFair:
        return AppColors.warning;
      case AppStrings.passwordStrengthStrong:
        return AppColors.success;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushNamed(
            context,
            RoutesNames.emailVerificationView,
            arguments: _emailController.text.trim(),
          );
        } else if (state is AuthSellerSuccess) {
          Navigator.pushNamed(context, RoutesNames.businessDetailsView);
        } else if (state is AuthFail) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        final passwordStrength =
            _getPasswordStrength(_passwordController.text);

        return Column(
          children: [
            if (_errorMessage != null)
              AuthErrorBanner(
                message: _errorMessage!,
                onClose: () => setState(() => _errorMessage = null),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding.w,
                  vertical: AppConstants.paddingL.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header ---
                      const CreateAccountHeader(),
                      SizedBox(height: 28.h),

                // --- Account Type Dropdown ---
                CustomDropdownField<AccountType>(
                  label: AppStrings.accountTypeLabel,
                  hint: AppStrings.accountTypeUser,
                  value: _selectedAccountType,
                  items: const [
                    DropdownMenuItem(
                      value: AccountType.user,
                      child: Text(AppStrings.accountTypeUser),
                    ),
                    DropdownMenuItem(
                      value: AccountType.seller,
                      child: Text(AppStrings.accountTypeSeller),
                    ),
                    DropdownMenuItem(
                      value: AccountType.charity,
                      child: Text(AppStrings.accountTypeCharity),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedAccountType = value);
                      context
                          .read<AuthCubit>()
                          .changeAccountType(value);
                    }
                  },
                ),
                SizedBox(height: 20.h),

                // --- Form Fields ---
                CreateAccountFormFields(
                  fullNameController: _fullNameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  passwordStrength: passwordStrength,
                  passwordStrengthColor: _getPasswordStrengthColor(passwordStrength),
                  onPasswordChanged: (_) => setState(() {}),
                ),
                SizedBox(height: 24.h),

                // --- Terms & Privacy ---
                CreateAccountTermsSection(
                  agreedToTerms: _agreedToTerms,
                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                ),
                SizedBox(height: 32.h),

                // --- Continue Button ---
                CustomButton(
                  label: AppStrings.continueButton,
                  suffixIcon: Icons.arrow_forward_rounded,
                  isLoading: isLoading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (!_agreedToTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.mustAgreeToTerms),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }
                      context.read<AuthCubit>().proceedToBusinessDetails(
                            fullName: _fullNameController.text.trim(),
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                            phoneNumber: _phoneController.text.trim(),
                          );
                    }
                  },
                ),
                SizedBox(height: 20.h),

                // --- Footer ---
                const CreateAccountFooter(),
                SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
