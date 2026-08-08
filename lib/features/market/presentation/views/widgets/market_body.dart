import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/presentation/manager/products_cubit/products_cubit.dart';
import 'package:foodloop/features/market/presentation/manager/products_cubit/products_state.dart';
import 'package:foodloop/features/market/presentation/views/widgets/market_active_order_bar.dart';
import 'package:foodloop/features/market/presentation/views/widgets/market_category_chips.dart';
import 'package:foodloop/features/market/presentation/views/widgets/market_section_header.dart';
import 'package:foodloop/features/market/presentation/views/widgets/nearby_deal_card.dart';
import 'package:foodloop/features/market/presentation/views/widgets/recommended_product_card.dart';
import 'package:foodloop/features/market/presentation/views/widgets/trending_item_card.dart';

class MarketBody extends StatefulWidget {
  const MarketBody({super.key});

  @override
  State<MarketBody> createState() => _MarketBodyState();
}

class _MarketBodyState extends State<MarketBody> {
  static const int _homePageSize = 20;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<ProductsCubit>().loadProducts(pageSize: _homePageSize);
  }

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

    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsFail) {
          return _MarketError(message: state.message, onRetry: _load);
        }

        if (state is! ProductsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = state.page.items;
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: Text(
                AppStrings.noResultsSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }

        final sections = _MarketSections.split(items);

        return ListView(
          padding: EdgeInsets.only(
            top: AppConstants.paddingS.h,
            bottom: AppConstants.paddingL.h,
          ),
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
            if (sections.recommended.isNotEmpty) ...[
              MarketSectionHeader(
                title: AppStrings.recommendedTitle,
                showViewAll: true,
              ),
              SizedBox(height: AppConstants.paddingS.h),
              _HorizontalList(
                height: 290.h,
                itemCount: sections.recommended.length,
                itemBuilder: (context, index) {
                  final product = sections.recommended[index];
                  return RecommendedProductCard(
                    product: product,
                    onTap: () => _openProduct(context, product),
                  );
                },
              ),
              SizedBox(height: AppConstants.paddingL.h),
            ],

            // --- Nearby deals ---
            if (sections.deals.isNotEmpty) ...[
              MarketSectionHeader(
                title: AppStrings.nearbyDealsTitle,
                trailingIcon: Icons.bolt_rounded,
              ),
              SizedBox(height: AppConstants.paddingS.h),
              _HorizontalList(
                height: 210.h,
                itemCount: sections.deals.length,
                itemBuilder: (context, index) {
                  final product = sections.deals[index];
                  return NearbyDealCard(
                    product: product,
                    onTap: () => _openProduct(context, product),
                  );
                },
              ),
              SizedBox(height: AppConstants.paddingL.h),
            ],

            // --- Trending grid ---
            if (sections.trending.isNotEmpty) ...[
              MarketSectionHeader(title: AppStrings.trendingTitle),
              SizedBox(height: AppConstants.paddingS.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontal),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sections.trending.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppConstants.paddingS.h,
                    crossAxisSpacing: AppConstants.paddingS.w,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, index) {
                    final product = sections.trending[index];
                    return TrendingItemCard(
                      product: product,
                      onTap: () => _openProduct(context, product),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// The listings endpoint returns one flat, ranked page — there's no
/// server-side notion of "recommended" / "deals" / "trending" to request
/// separately, so the home screen's three sections are carved out of that
/// single page client-side: the first slice is "Recommended", items with an
/// active discount become "Nearby Deals" (falling back to the next slice
/// when nothing is discounted), and whatever remains is "Trending".
class _MarketSections {
  final List<ProductModel> recommended;
  final List<ProductModel> deals;
  final List<ProductModel> trending;

  const _MarketSections({
    required this.recommended,
    required this.deals,
    required this.trending,
  });

  factory _MarketSections.split(List<ProductModel> items) {
    final recommended = items.take(6).toList();
    var remainder = items.skip(recommended.length).toList();

    var deals = remainder.where((p) => p.discountPercent != null).toList();
    if (deals.isEmpty) {
      deals = remainder.take(4).toList();
    }
    final trending = remainder.where((p) => !deals.contains(p)).toList();

    return _MarketSections(
      recommended: recommended,
      deals: deals,
      trending: trending.isEmpty ? remainder : trending,
    );
  }
}

class _MarketError extends StatelessWidget {
  const _MarketError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 40.r, color: AppColors.error),
            SizedBox(height: AppConstants.paddingS.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppConstants.paddingM.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.retry,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
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
