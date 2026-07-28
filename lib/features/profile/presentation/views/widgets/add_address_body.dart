import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/features/profile/data/models/address_model.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/add_address_form_fields.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/add_address_map_section.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/address_label_selector.dart';

class AddAddressBody extends StatefulWidget {
  const AddAddressBody({super.key});

  @override
  State<AddAddressBody> createState() => _AddAddressBodyState();
}

class _AddAddressBodyState extends State<AddAddressBody> {
  final _formKey = GlobalKey<FormState>();
  final _districtController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _notesController = TextEditingController();

  AddressType _addressType = AddressType.home;
  String? _selectedCity;

  @override
  void dispose() {
    _districtController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    // Static screen: the AddressModel is assembled but not yet persisted.
    // Wire `context.read<ProfileCubit>().addAddress(address)` here later.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppConstants.screenHorizontalPadding.w,
                AppConstants.paddingS.h,
                AppConstants.screenHorizontalPadding.w,
                AppConstants.paddingL.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Map ---
                  const AddAddressMapSection(),
                  SizedBox(height: AppConstants.paddingL.h),

                  // --- Address label ---
                  const _SectionCaption(AppStrings.addressLabelSectionTitle),
                  SizedBox(height: AppConstants.paddingS.h),
                  AddressLabelSelector(
                    selected: _addressType,
                    onChanged: (type) => setState(() => _addressType = type),
                  ),
                  SizedBox(height: AppConstants.paddingL.h),

                  // --- Address details ---
                  const _SectionCaption(AppStrings.addressDetailsSectionTitle),
                  SizedBox(height: AppConstants.paddingS.h),
                  AddAddressFormFields(
                    selectedCity: _selectedCity,
                    onCityChanged: (v) => setState(() => _selectedCity = v),
                    districtController: _districtController,
                    streetController: _streetController,
                    buildingController: _buildingController,
                    floorController: _floorController,
                    apartmentController: _apartmentController,
                    notesController: _notesController,
                  ),
                ],
              ),
            ),
          ),
        ),

        // --- Bottom save bar ---
        _SaveBar(onSave: _onSave),
      ],
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'DmSans',
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.outline,
      ),
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingM.h,
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingM.h,
          ),
          child: CustomButton(
            label: AppStrings.saveAddress,
            suffixIcon: Icons.save_rounded,
            onTap: onSave,
          ),
        ),
      ),
    );
  }
}
