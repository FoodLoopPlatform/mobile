import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/market/data/data_sources/products_remote_data_source.dart';
import 'package:foodloop/features/market/data/repositories/products_repository.dart';
import 'package:foodloop/features/market/presentation/manager/products_cubit/products_cubit.dart';
import 'package:foodloop/features/market/presentation/views/widgets/market_body.dart';

class MarketView extends StatelessWidget {
  const MarketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 20.w,
        title: Row(
          children: [
            Icon(Icons.eco_rounded, size: 24.r, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              AppStrings.marketBrand,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RoutesNames.searchView),
            icon: Icon(Icons.search_rounded,
                size: 24.r, color: AppColors.textSecondary),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: BlocProvider(
        create: (context) => ProductsCubit(
          ProductsRepository(
            ProductsRemoteDataSource(context.read<ApiManager>()),
          ),
        ),
        child: const MarketBody(),
      ),
    );
  }
}
