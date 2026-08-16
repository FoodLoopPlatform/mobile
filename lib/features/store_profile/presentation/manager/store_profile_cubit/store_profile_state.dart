import 'package:equatable/equatable.dart';
import 'package:foodloop/features/store_profile/data/models/store_details_model.dart';

abstract class StoreProfileState extends Equatable {
  const StoreProfileState();
  @override
  List<Object?> get props => [];
}

class StoreProfileInitial extends StoreProfileState {
  const StoreProfileInitial();
}

class StoreProfileLoading extends StoreProfileState {
  const StoreProfileLoading();
}

class StoreProfileLoaded extends StoreProfileState {
  final StoreDetailsModel store;
  final List<StoreReviewModel> reviews;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMoreReviews;

  const StoreProfileLoaded({
    required this.store,
    required this.reviews,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMoreReviews = false,
  });

  bool get hasMoreReviews => currentPage < totalPages;

  StoreProfileLoaded copyWith({
    StoreDetailsModel? store,
    List<StoreReviewModel>? reviews,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMoreReviews,
  }) {
    return StoreProfileLoaded(
      store: store ?? this.store,
      reviews: reviews ?? this.reviews,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMoreReviews: isLoadingMoreReviews ?? this.isLoadingMoreReviews,
    );
  }

  @override
  List<Object?> get props =>
      [store, reviews, currentPage, totalPages, isLoadingMoreReviews];
}

class StoreProfileError extends StoreProfileState {
  final String message;
  const StoreProfileError(this.message);
  @override
  List<Object?> get props => [message];
}
