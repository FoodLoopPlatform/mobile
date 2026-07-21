import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/widgets/custom_dropdown_field.dart';
import 'package:foodloop/core/widgets/custom_text_field.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/map_placeholder.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/section_header.dart';

class BusinessDetailsLocationSection extends StatelessWidget {
  const BusinessDetailsLocationSection({
    super.key,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.governorates,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.neighborhoodController,
    required this.streetController,
  });

  final String? selectedGovernorate;
  final String? selectedCity;
  final List<String> governorates;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final TextEditingController neighborhoodController;
  final TextEditingController streetController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: Icons.location_on_outlined,
          title: AppStrings.locationSectionTitle,
        ),
        SizedBox(height: 16.h),
        CustomDropdownField<String>(
          label: AppStrings.governorateLabel,
          hint: AppStrings.governorateHint,
          value: selectedGovernorate,
          items: governorates
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: onGovernorateChanged,
          validator: (v) => v == null || v.isEmpty ? AppStrings.fieldRequired : null,
        ),
        SizedBox(height: 16.h),
        CustomDropdownField<String>(
          label: AppStrings.cityLabel,
          hint: AppStrings.cityHint,
          value: selectedCity,
          items: const [
            DropdownMenuItem(value: 'Nasr City', child: Text('Nasr City')),
            DropdownMenuItem(value: 'Heliopolis', child: Text('Heliopolis')),
            DropdownMenuItem(value: 'Maadi', child: Text('Maadi')),
            DropdownMenuItem(value: 'Zamalek', child: Text('Zamalek')),
            DropdownMenuItem(value: 'Downtown', child: Text('Downtown')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: onCityChanged,
          validator: (v) => v == null || v.isEmpty ? AppStrings.fieldRequired : null,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: AppStrings.neighborhoodLabel,
          hint: AppStrings.neighborhoodHint,
          controller: neighborhoodController,
          keyboardType: TextInputType.streetAddress,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: AppStrings.streetLabel,
          hint: AppStrings.streetHint,
          controller: streetController,
          keyboardType: TextInputType.streetAddress,
        ),
        SizedBox(height: 20.h),
        const MapPlaceholder(),
        SizedBox(height: 8.h),
        Text(
          AppStrings.mapHint,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 11.sp,
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }
}
