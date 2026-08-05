import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/data/sample_products.dart';
import 'package:foodloop/features/market/presentation/views/widgets/market_active_order_bar.dart';
import 'package:foodloop/features/market/presentation/views/widgets/market_category_chips.dart';
import 'package:foodloop/features/market/presentation/views/widgets/market_section_header.dart';
import 'package:foodloop/features/market/presentation/views/widgets/nearby_deal_card.dart';
import 'package:foodloop/features/market/presentation/views/widgets/recommended_product_card.dart';
import 'package:foodloop/features/market/presentation/views/widgets/trending_item_card.dart';

class MarketBody extends StatelessWidget {
  const MarketBody({super.key});

  void _openProduct(BuildContext context, ProductModel product) {
    Navigator.pushNamed(
      context,
      RoutesNames.productDetailsView,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontal = AppConstants.screenHorizontalPadding.w;

    return ListView(
      padding: EdgeInsets.only(top: AppConstants.paddingS.h, bottom: AppConstants.paddingL.h),
      children: [
        // --- Active order ---
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontal),
          child: const MarketActiveOrderBar(),
        ),
        SizedBox(height: AppConstants.paddingM.h),

        // --- Categories ---
        const MarketCategoryChips(),
        SizedBox(height: AppConstants.paddingL.h),

        // --- Recommended ---
        const MarketSectionHeader(
          title: AppStrings.recommendedTitle,
          showViewAll: true,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        _HorizontalList(
          height: 290.h,
          itemCount: SampleProducts.recommended.length,
          itemBuilder: (context, index) {
            final product = SampleProducts.recommended[index];
            return RecommendedProductCard(
              product: product,
              onTap: () => _openProduct(context, product),
            );
          },
        ),
        SizedBox(height: AppConstants.paddingL.h),

        // --- Nearby deals ---
        const MarketSectionHeader(
          title: AppStrings.nearbyDealsTitle,
          trailingIcon: Icons.bolt_rounded,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        _HorizontalList(
          height: 210.h,
          itemCount: SampleProducts.nearbyDeals.length,
          itemBuilder: (context, index) {
            final product = SampleProducts.nearbyDeals[index];
            return NearbyDealCard(
              product: product,
              onTap: () => _openProduct(context, product),
            );
          },
        ),
        SizedBox(height: AppConstants.paddingL.h),

        // --- Trending grid ---
        const MarketSectionHeader(title: AppStrings.trendingTitle),
        SizedBox(height: AppConstants.paddingS.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontal),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: SampleProducts.trending.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppConstants.paddingS.h,
              crossAxisSpacing: AppConstants.paddingS.w,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final product = SampleProducts.trending[index];
              return TrendingItemCard(
                product: product,
                onTap: () => _openProduct(context, product),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Edge-to-edge horizontal carousel with screen-padding insets.
class _HorizontalList extends StatelessWidget {
  const _HorizontalList({
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
  });

  final double height;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding.w,
        ),
        itemCount: itemCount,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppConstants.paddingM.w),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
