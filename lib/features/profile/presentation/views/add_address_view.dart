import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/profile/data/models/address_model.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/add_address_body.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({super.key, this.address});

  /// Null creates a new address; otherwise the screen edits [address].
  final AddressModel? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.primary),
        title: Text(
          address == null
              ? AppStrings.addAddressTitle
              : AppStrings.editAddressTitle,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_rounded,
              color: AppColors.textSecondary,
              size: 24.r,
            ),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: AddAddressBody(address: address),
    );
  }
}
