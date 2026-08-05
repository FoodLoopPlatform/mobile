import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/utils/egypt_cities.dart';
import 'package:foodloop/core/utils/validation.dart';
import 'package:foodloop/core/widgets/custom_dropdown_field.dart';
import 'package:foodloop/core/widgets/custom_text_field.dart';

class AddAddressFormFields extends StatelessWidget {
  const AddAddressFormFields({
    super.key,
    required this.selectedCity,
    required this.onCityChanged,
    required this.districtController,
    required this.streetController,
    required this.buildingController,
    required this.floorController,
    required this.apartmentController,
    required this.notesController,
  });

  final String? selectedCity;
  final ValueChanged<String?> onCityChanged;
  final TextEditingController districtController;
  final TextEditingController streetController;
  final TextEditingController buildingController;
  final TextEditingController floorController;
  final TextEditingController apartmentController;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- City ---
        CustomDropdownField<String>(
          hint: AppStrings.selectCityHint,
          value: selectedCity,
          items: EgyptCities.all
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: onCityChanged,
          validator: (v) =>
              v == null || v.isEmpty ? AppStrings.fieldRequired : null,
        ),
        SizedBox(height: AppConstants.paddingS.h),

        // --- District ---
        CustomTextField(
          hint: AppStrings.districtHint,
          controller: districtController,
          validator: Validation.validateRequiredField,
        ),
        SizedBox(height: AppConstants.paddingS.h),

        // --- Street ---
        CustomTextField(
          hint: AppStrings.streetNameHint,
          controller: streetController,
          keyboardType: TextInputType.streetAddress,
          validator: Validation.validateRequiredField,
        ),
        SizedBox(height: AppConstants.paddingS.h),

        // --- Building + Floor ---
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                hint: AppStrings.buildingNoHint,
                controller: buildingController,
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(width: AppConstants.paddingS.w),
            Expanded(
              child: CustomTextField(
                hint: AppStrings.floorHint,
                controller: floorController,
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.paddingS.h),

        // --- Apartment ---
        CustomTextField(
          hint: AppStrings.apartmentNoHint,
          controller: apartmentController,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: AppConstants.paddingS.h),

        // --- Notes ---
        CustomTextField(
          hint: AppStrings.addressNotesHint,
          controller: notesController,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
        ),
      ],
    );
  }
}
