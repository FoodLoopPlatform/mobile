import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitReport() {
    if (_selectedReason == null || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.reportMissingImageError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    context.read<ReportProductCubit>().reportProduct(
          productId: widget.productId,
          reason: _selectedReason!,
          details: _detailsController.text.trim(),
          imagePath: _selectedImage!.path,
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
                SizedBox(height: AppConstants.paddingM.h),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.outlineVariant),
                      borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, color: AppColors.neutral, size: 32.sp),
                              SizedBox(height: AppConstants.paddingS.h),
                              Text(
                                AppStrings.reportImageLabel,
                                style: TextStyle(color: AppColors.neutral, fontSize: 14.sp),
                              ),
                            ],
                          ),
                  ),
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
