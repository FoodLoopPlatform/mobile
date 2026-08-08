import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/expiration_details_body.dart';

class ExpirationDetailsView extends StatelessWidget {
  const ExpirationDetailsView({super.key, required this.draft});

  final ProductDraft draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.primary),
        title: Text(
          AppStrings.expirationTitle,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: ExpirationDetailsBody(draft: draft),
    );
  }
}
