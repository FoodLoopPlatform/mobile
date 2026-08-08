import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/data/sample_products.dart';
import 'package:foodloop/features/search/presentation/views/widgets/search_empty_state.dart';
import 'package:foodloop/features/search/presentation/views/widgets/search_field.dart';
import 'package:foodloop/features/search/presentation/views/widgets/search_filter_chips.dart';
import 'package:foodloop/features/search/presentation/views/widgets/search_result_card.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key});

  @override
  State<SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Matches on product name or seller. An empty query browses everything.
  List<ProductModel> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return SampleProducts.all;
    return SampleProducts.all
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.seller.toLowerCase().contains(q))
        .toList();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() => _query = '');
  }

  void _openProduct(ProductModel product) {
    Navigator.pushNamed(
      context,
      RoutesNames.productDetailsView,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    final hasQuery = _query.trim().isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingS.h,
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingS.h,
          ),
          child: SearchField(
            controller: _controller,
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        const SearchFilterChips(),
        SizedBox(height: AppConstants.paddingM.h),
        Expanded(
          child: hasQuery && results.isEmpty
              ? SearchEmptyState(
                  query: _query.trim(),
                  onBrowseAll: _clearSearch,
                  onClearFilters: _clearSearch,
                )
              : _Results(results: results, onOpen: _openProduct),
        ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.results, required this.onOpen});

  final List<ProductModel> results;
  final ValueChanged<ProductModel> onOpen;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.screenHorizontalPadding.w,
          ),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppStrings.localHarvestDeals,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${results.length} ${AppStrings.resultsCountSuffix}',
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingM.h,
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingL.h,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppConstants.paddingM.h,
              crossAxisSpacing: AppConstants.paddingM.w,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = results[index];
                return SearchResultCard(
                  product: product,
                  onTap: () => onOpen(product),
                );
              },
              childCount: results.length,
            ),
          ),
        ),
      ],
    );
  }
}
