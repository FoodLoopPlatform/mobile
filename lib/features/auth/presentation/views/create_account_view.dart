import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:foodloop/features/auth/presentation/views/widgets/create_account_body.dart';

class CreateAccountView extends StatelessWidget {
  const CreateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: Text(
            AppStrings.appName,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          centerTitle: false,
        ),
        body: const CreateAccountBody(),
      ),
    );
  }
}
