import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
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

  final List<String> _governorates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Qalyubia',
    'Sharqia',
    'Dakahlia',
    'Beheira',
    'Monufia',
    'Gharbia',
    'Kafr El Sheikh',
    'Damietta',
    'Port Said',
    'Ismailia',
    'Suez',
    'North Sinai',
    'South Sinai',
    'Red Sea',
    'Matrouh',
    'Fayoum',
    'Beni Suef',
    'Minya',
    'Assiut',
    'Sohag',
    'Qena',
    'Luxor',
    'Aswan',
    'New Valley',
  ];

  @override
  void dispose() {
    _neighborhoodController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(
                        context,
                        RoutesNames.emailVerificationView,
                        arguments: '',
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
  }
}

