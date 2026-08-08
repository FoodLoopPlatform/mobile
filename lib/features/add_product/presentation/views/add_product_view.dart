import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/add_product_body.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.primary),
        title: Text(
          AppStrings.addProductTitle,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: const AddProductBody(),
    );
  }
}
