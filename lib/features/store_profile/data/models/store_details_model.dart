import 'dart:convert';
import 'package:equatable/equatable.dart';

class RatingDistribution extends Equatable {
  final int stars;
  final int count;

  const RatingDistribution({required this.stars, required this.count});

  factory RatingDistribution.fromJson(Map<String, dynamic> json) {
    return RatingDistribution(
      stars: (json['stars'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [stars, count];
}

class StoreReviewModel extends Equatable {
  final String id;
  final String userId;
  final String userFullName;
  final String organizationId;
  final String organizationName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const StoreReviewModel({
    required this.id,
    required this.userId,
    required this.userFullName,
    required this.organizationId,
    required this.organizationName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory StoreReviewModel.fromJson(Map<String, dynamic> json) {
    return StoreReviewModel(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userFullName: json['userFullName']?.toString() ?? '',
      organizationId: json['organizationId']?.toString() ?? '',
      organizationName: json['organizationName']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, userId, rating];
}

class StoreDetailsModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? logo;
  final String? coverPhoto;
  final String phone;
  final String email;
  final String businessCategory;
  final String governorate;
  final String city;
  final String neighborhood;
  final String street;
  final String buildingNo;
  final double latitude;
  final double longitude;

  /// Raw JSON string from API: e.g. {"Monday": {"open":"08:00","close":"23:00"}, ...}
  final String openingHoursRaw;
  final String verificationStatus;
  final double averageRating;
  final int totalReviews;
  final List<RatingDistribution> ratingDistribution;
  final List<StoreReviewModel> recentReviews;

  const StoreDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    this.logo,
    this.coverPhoto,
    required this.phone,
    required this.email,
    required this.businessCategory,
    required this.governorate,
    required this.city,
    required this.neighborhood,
    required this.street,
    required this.buildingNo,
    required this.latitude,
    required this.longitude,
    required this.openingHoursRaw,
    required this.verificationStatus,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    required this.recentReviews,
  });

  factory StoreDetailsModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    final distList = (json['ratingDistribution'] as List<dynamic>? ?? [])
        .map((e) => RatingDistribution.fromJson(e as Map<String, dynamic>))
        .toList();

    final reviewsList = (json['recentReviews'] as List<dynamic>? ?? [])
        .map((e) => StoreReviewModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return StoreDetailsModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      logo: json['logo']?.toString(),
      coverPhoto: json['coverPhoto']?.toString(),
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      businessCategory: json['businessCategory']?.toString() ?? '',
      governorate: json['governorate']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      neighborhood: json['neighborhood']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      buildingNo: json['buildingNo']?.toString() ?? '',
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
      openingHoursRaw: json['openingHours']?.toString() ?? '{}',
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      averageRating: toDouble(json['averageRating']),
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      ratingDistribution: distList,
      recentReviews: reviewsList,
    );
  }

  /// Parses [openingHoursRaw] and determines if the store is currently open.
  bool get isOpenNow {
    try {
      final raw = jsonDecode(openingHoursRaw) as Map<String, dynamic>;
      final now = DateTime.now();
      final dayNames = [
        'Sunday',
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
      ];
      final todayKey = dayNames[now.weekday % 7];
      final todayHours = raw[todayKey] as Map<String, dynamic>?;
      if (todayHours == null) return false;

      final openParts = (todayHours['open'] as String).split(':');
      final closeParts = (todayHours['close'] as String).split(':');

      final openMinutes =
          int.parse(openParts[0]) * 60 + int.parse(openParts[1]);
      final closeMinutes =
          int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);
      final nowMinutes = now.hour * 60 + now.minute;

      return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
    } catch (_) {
      return false;
    }
  }

  /// Returns the full street address as a single string.
  String get fullAddress =>
      '$buildingNo $street, $neighborhood, $city, $governorate';

  @override
  List<Object?> get props => [id, name, averageRating, totalReviews];
}
