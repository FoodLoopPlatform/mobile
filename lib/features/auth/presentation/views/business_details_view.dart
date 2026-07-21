import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/business_details_body.dart';

class BusinessDetailsView extends StatelessWidget {
  const BusinessDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          AppStrings.businessDetailsTitle,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: const BusinessDetailsBody(),
    );
  }
}
