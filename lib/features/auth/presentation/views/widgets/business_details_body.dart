import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_state.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/auth_error_banner.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/business_details_legal_section.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/business_details_location_section.dart';

class BusinessDetailsBody extends StatefulWidget {
  const BusinessDetailsBody({super.key});

  @override
  State<BusinessDetailsBody> createState() => _BusinessDetailsBodyState();
}

class _BusinessDetailsBodyState extends State<BusinessDetailsBody> {
  final _formKey = GlobalKey<FormState>();
  final _neighborhoodController = TextEditingController();
  final _streetController = TextEditingController();
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _errorMessage;

  final List<String> _governorates = [
    'Cairo', 'Giza', 'Alexandria', 'Qalyubia', 'Sharqia', 'Dakahlia', 'Beheira',
    'Monufia', 'Gharbia', 'Kafr El Sheikh', 'Damietta', 'Port Said', 'Ismailia',
    'Suez', 'North Sinai', 'South Sinai', 'Red Sea', 'Matrouh', 'Fayoum',
    'Beni Suef', 'Minya', 'Assiut', 'Sohag', 'Qena', 'Luxor', 'Aswan', 'New Valley',
  ];

  @override
  void dispose() {
    _neighborhoodController.dispose();
    _streetController.dispose();
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
          Navigator.pushNamed(
            context,
            RoutesNames.emailVerificationView,
            arguments: state.email,
          );
        } else if (state is AuthFail) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Column(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Subtitle ---
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                                text:
                                    'Help us verify your organization to start reducing food waste. We ensure all partners meet local safety and '),
                            TextSpan(
                              text: 'legal standards',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // =========================================
                      // LOCATION SECTION
                      // =========================================
                      BusinessDetailsLocationSection(
                        selectedGovernorate: _selectedGovernorate,
                        selectedCity: _selectedCity,
                        governorates: _governorates,
                        onGovernorateChanged: (v) => setState(() => _selectedGovernorate = v),
                        onCityChanged: (v) => setState(() => _selectedCity = v),
                        neighborhoodController: _neighborhoodController,
                        streetController: _streetController,
                      ),
                      SizedBox(height: 32.h),

                      // =========================================
                      // LEGAL DOCUMENTS SECTION
                      // =========================================
                      const BusinessDetailsLegalSection(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // =========================================
              // BOTTOM BAR
              // =========================================
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                      top: BorderSide(color: AppColors.border, width: 0.5)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      label: AppStrings.submitForVerification,
                      suffixIcon: Icons.arrow_forward_rounded,
                      isLoading: isLoading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().register(
                            role: context.read<AuthCubit>().selectedAccountType.toBackendRole(),
                            businessName: '$_selectedGovernorate - ${_streetController.text}',
                            businessCategory: 'Store',
                            documentFile: null, // No file picking UI yet
                          );
                        }
                      },
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline_rounded,
                            size: 12.r, color: AppColors.neutral),
                        SizedBox(width: 4.w),
                        Text(
                          AppStrings.dataSecurityNote,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 11.sp,
                            color: AppColors.neutral,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

