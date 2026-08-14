import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/orders/presentation/manager/orders_cubit/orders_cubit.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_cubit.dart';
import 'package:foodloop/features/support/presentation/views/widgets/create_ticket_body.dart';

class CreateTicketView extends StatelessWidget {
  const CreateTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SupportCubit()),
        BlocProvider(create: (_) => OrdersCubit()..loadOrders()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20.r,
              color: AppColors.primary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            AppStrings.supportCenterTitle,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          centerTitle: true,
        ),
        body: const CreateTicketBody(),
      ),
    );
  }
}
