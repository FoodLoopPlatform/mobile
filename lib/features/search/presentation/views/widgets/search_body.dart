import 'dart:async';

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
  static const int _pageSize = 20;
  static const _debounceDelay = Duration(milliseconds: 400);

  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    context.read<ProductsCubit>().loadProducts(
          search: _query.trim().isEmpty ? null : _query.trim(),
          pageSize: _pageSize,
        );
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
    _debounce?.cancel();
    _debounce = Timer(_debounceDelay, _search);
  }

  void _clearSearch() {
    _controller.clear();
    _debounce?.cancel();
    setState(() => _query = '');
    _search();
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
            onChanged: _onQueryChanged,
          ),
        ),
        const SearchFilterChips(),
        SizedBox(height: AppConstants.paddingM.h),
        Expanded(
          child: BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsFail) {
                return _SearchError(message: state.message, onRetry: _search);
              }

              if (state is! ProductsLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              final results = state.page.items;

              if (results.isEmpty) {
                return hasQuery
                    ? SearchEmptyState(
                        query: _query.trim(),
                        onBrowseAll: _clearSearch,
                        onClearFilters: _clearSearch,
                      )
                    : Center(
                        child: Text(
                          AppStrings.noResultsSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
              }

              return _Results(results: results, onOpen: _openProduct);
            },
          ),
        ),
      ],
    );
  }
}

class _SearchError extends StatelessWidget {
  const _SearchError({required this.message, required this.onRetry});

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
