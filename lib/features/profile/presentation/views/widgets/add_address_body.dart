import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/utils/egypt_cities.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/features/profile/data/models/address_model.dart';
import 'package:foodloop/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:foodloop/features/profile/presentation/manager/profile_cubit/profile_state.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/add_address_form_fields.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/add_address_map_section.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/address_label_selector.dart';

class AddAddressBody extends StatefulWidget {
  const AddAddressBody({super.key, this.address});

  /// Null creates a new address; otherwise the form edits [address].
  final AddressModel? address;

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
  LatLng? _pickedLocation;
  bool _isSaving = false;

  bool get _isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    if (address == null) return;

    _addressType = address.addressType;
    _selectedCity = EgyptCities.all.contains(address.city) ? address.city : null;
    _districtController.text = address.district;
    _streetController.text = address.street;
    _buildingController.text = address.buildingNo ?? '';
    _floorController.text = address.floor ?? '';
    _apartmentController.text = address.apartmentNo ?? '';
    _notesController.text = address.notes ?? '';

    if (address.latitude != null && address.longitude != null) {
      _pickedLocation = LatLng(address.latitude!, address.longitude!);
    }
  }

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

  String? _orNull(String text) => text.trim().isEmpty ? null : text.trim();

  /// Mirrors the map pin into the form. Only fields the geocoder could actually
  /// name are overwritten, so a failed lookup never wipes what the user typed.
  void _onLocationPicked(PickedLocation location) {
    _pickedLocation = location.position;

    final city = location.city;
    final district = location.district;
    final street = location.street;

    if (city == null && district == null && street == null) return;

    setState(() {
      if (city != null) _selectedCity = city;
      if (district != null) _districtController.text = district;
      if (street != null) _streetController.text = street;
    });
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final address = AddressModel(
      addressType: _addressType,
      city: _selectedCity!,
      district: _districtController.text.trim(),
      street: _streetController.text.trim(),
      buildingNo: _orNull(_buildingController.text),
      floor: _orNull(_floorController.text),
      apartmentNo: _orNull(_apartmentController.text),
      notes: _orNull(_notesController.text),
      latitude: _pickedLocation?.latitude,
      longitude: _pickedLocation?.longitude,
      // Editing must not silently drop the default flag.
      isDefault: widget.address?.isDefault ?? false,
    );

    final cubit = context.read<ProfileCubit>();
    if (_isEditing) {
      await cubit.updateAddress(widget.address!.id, address.toRequestJson());
    } else {
      await cubit.addAddress(address);
    }
    if (!mounted) return;

    setState(() => _isSaving = false);

    final state = cubit.state;
    if (state is ProfileLoaded && state.actionError != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.actionError!)));
      return;
    }

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
                  AddAddressMapSection(
                    onLocationPicked: _onLocationPicked,
                    initialLocation: _pickedLocation,
                  ),
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
        _SaveBar(onSave: _onSave, isSaving: _isSaving),
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
  const _SaveBar({required this.onSave, required this.isSaving});

  final VoidCallback onSave;
  final bool isSaving;

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
            isLoading: isSaving,
            onTap: onSave,
          ),
        ),
      ),
    );
  }
}
