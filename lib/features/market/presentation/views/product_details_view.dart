import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/market/data/data_sources/products_remote_data_source.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/data/repositories/products_repository.dart';
import 'package:foodloop/features/market/presentation/manager/report_product_cubit/report_product_cubit.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_details_body.dart';
import 'package:foodloop/features/market/presentation/views/widgets/report_product_dialog.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.product});

  final ProductModel product;

  void _showReportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return BlocProvider(
          create: (_) => ReportProductCubit(
            ProductsRepository(
              ProductsRemoteDataSource(context.read<ApiManager>()),
            ),
          ),
          child: ReportProductDialog(productId: product.id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.primary),
        centerTitle: true,
        title: Text(
          AppStrings.marketBrand,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border_rounded,
                size: 24.r, color: AppColors.primary),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: AppColors.primary),
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report_problem_outlined, color: AppColors.error, size: 20.r),
                    SizedBox(width: 12.w),
                    Text(
                      AppStrings.reportProductTitle,
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: ProductDetailsBody(product: product),
    );
  }
}
