import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_cubit.dart';
import 'package:foodloop/features/support/presentation/views/widgets/ticket_details_body.dart';

class TicketDetailsView extends StatelessWidget {
  const TicketDetailsView({super.key, required this.ticketId});

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportCubit()..loadTicketDetail(ticketId),
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
        body: TicketDetailsBody(ticketId: ticketId),
      ),
    );
  }
}
