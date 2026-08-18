import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_dropdown_field.dart';
import 'package:foodloop/core/widgets/custom_text_field.dart';
import 'package:foodloop/features/market/presentation/manager/report_product_cubit/report_product_cubit.dart';
import 'package:foodloop/features/market/presentation/manager/report_product_cubit/report_product_state.dart';

class ReportProductDialog extends StatefulWidget {
  final String productId;

  const ReportProductDialog({super.key, required this.productId});

  @override
  State<ReportProductDialog> createState() => _ReportProductDialogState();
}

class _ReportProductDialogState extends State<ReportProductDialog> {
  final _detailsController = TextEditingController();
  String? _selectedReason;

  final List<String> _reasonOptions = [
    'MisleadingInfo',
    'WrongExpiry',
    'Spam',
    'Inapprop',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_selectedReason == null) return;
    context.read<ReportProductCubit>().reportProduct(
          productId: widget.productId,
          reason: _selectedReason!,
          details: _detailsController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportProductCubit, ReportProductState>(
      listener: (context, state) {
        if (state is ReportProductSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.reportSuccess),
              backgroundColor: AppColors.primary,
            ),
          );
          Navigator.pop(context);
        } else if (state is ReportProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: AppConstants.screenHorizontalPadding.w,
            right: AppConstants.screenHorizontalPadding.w,
            top: AppConstants.paddingL.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: AppConstants.paddingL.h),
                Text(
                  AppStrings.reportProductTitle,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppConstants.paddingL.h),
                CustomDropdownField<String>(
                  label: AppStrings.reportReasonLabel,
                  hint: AppStrings.reportReasonHint,
                  value: _selectedReason,
                  items: _reasonOptions.map((reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedReason = value;
                    });
                  },
                ),
                SizedBox(height: AppConstants.paddingM.h),
                CustomTextField(
                  controller: _detailsController,
                  label: AppStrings.reportDetailsLabel,
                  hint: AppStrings.reportDetailsHint,
                  maxLines: 4,
                ),
                SizedBox(height: AppConstants.paddingXL.h),
                CustomButton(
                  label: AppStrings.reportSubmit,
                  onTap: state is ReportProductLoading ? () {} : _submitReport,
                  isLoading: state is ReportProductLoading,
                ),
                SizedBox(height: AppConstants.paddingXL.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
