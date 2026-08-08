import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/verification_results_body.dart';

/// Arguments for the step 3 results screen.
class VerificationResultsArgs {
  final ProductDraft draft;
  final List<ExpirationBatch> batches;

  const VerificationResultsArgs({required this.draft, this.batches = const []});
}

class VerificationResultsView extends StatelessWidget {
  const VerificationResultsView({super.key, required this.args});

  final VerificationResultsArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.primary),
        title: Text(
          AppStrings.resultsTitle,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: VerificationResultsBody(
        draft: args.draft,
        batches: args.batches,
        // Back to step 2, where both the camera and the date fields live.
        onRetake: () => Navigator.pop(context),
      ),
    );
  }
}
