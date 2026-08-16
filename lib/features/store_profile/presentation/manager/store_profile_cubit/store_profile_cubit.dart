import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/features/store_profile/data/data_sources/store_remote_data_source.dart';
import 'package:foodloop/features/store_profile/data/models/store_details_model.dart';
import 'package:foodloop/features/store_profile/presentation/manager/store_profile_cubit/store_profile_state.dart';

class StoreProfileCubit extends Cubit<StoreProfileState> {
  final StoreRemoteDataSource _dataSource;

  static const int _pageSize = 10;

  StoreProfileCubit()
      : _dataSource = StoreRemoteDataSource(ApiManager()),
        super(const StoreProfileInitial());

  /// Fetches the store details and initial reviews.
  Future<void> fetchStoreProfile(String storeId) async {
    emit(const StoreProfileLoading());
    try {
      final store = await _dataSource.getStoreDetails(storeId);

      // Seed the reviews list with the recent reviews already in the details
      final initialReviews = List<StoreReviewModel>.from(store.recentReviews);

      emit(StoreProfileLoaded(
        store: store,
        reviews: initialReviews,
        currentPage: 1,
        totalPages: store.totalReviews > _pageSize
            ? (store.totalReviews / _pageSize).ceil()
            : 1,
      ));
    } catch (e) {
      emit(StoreProfileError(e.toString()));
    }
  }

  /// Loads the next page of reviews and appends them to the current list.
  Future<void> loadMoreReviews() async {
    final current = state;
    if (current is! StoreProfileLoaded) return;
    if (!current.hasMoreReviews) return;
    if (current.isLoadingMoreReviews) return;

    emit(current.copyWith(isLoadingMoreReviews: true));

    try {
      final nextPage = current.currentPage + 1;
      final result = await _dataSource.getStoreReviews(
        storeId: current.store.id,
        pageNumber: nextPage,
        pageSize: _pageSize,
      );
      final updatedReviews = [...current.reviews, ...result.reviews];
      emit(current.copyWith(
        reviews: updatedReviews,
        currentPage: nextPage,
        totalPages: result.totalPages,
        isLoadingMoreReviews: false,
      ));
    } catch (e) {
      // Revert the loading indicator without losing data
      emit(current.copyWith(isLoadingMoreReviews: false));
    }
  }
}
