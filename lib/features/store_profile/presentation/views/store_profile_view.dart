import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/store_profile/presentation/manager/store_profile_cubit/store_profile_cubit.dart';
import 'package:foodloop/features/store_profile/presentation/views/widgets/store_profile_body.dart';

class StoreProfileView extends StatelessWidget {
  const StoreProfileView({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreProfileCubit()..fetchStoreProfile(storeId),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.textPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppStrings.storeProfileTitle,
            style: const TextStyle(
              fontFamily: 'DmSans',
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              color: AppColors.textPrimary,
              onPressed: () {},
            ),
          ],
        ),
        body: const StoreProfileBody(),
      ),
    );
  }
}
