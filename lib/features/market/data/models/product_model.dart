import 'package:equatable/equatable.dart';

/// A market product, backed by `GET /marketplace/products`.
class ProductModel extends Equatable {
  final String id;
  final String name;
  final String seller;
  final String imageUrl;
  final double price;

  /// Original price when the item is discounted; null otherwise.
  final double? oldPrice;

  /// Short badge shown on the image (e.g. "عضوي" / "مخبوزات").
  final String? badge;

  /// Flash-deal countdown text (static, e.g. "04:03:56").
  final String? countdown;

  /// Trending subtitle (e.g. "الأفضل هذا الأسبوع").
  final String? tagline;

  final double rating;
  final int reviews;
  final bool inStock;
  final List<String> images;

  final String? organizationId;
  final String? categoryId;
  final String? description;
  final int? quantityAvailable;
  final String? expirationDate;
  final String? status;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  const ProductModel({
    required this.id,
    required this.name,
    required this.seller,
    required this.imageUrl,
    required this.price,
    this.oldPrice,
    this.badge,
    this.countdown,
    this.tagline,
    this.rating = 4.7,
    this.reviews = 1239,
    this.inStock = true,
    this.images = const [],
    this.organizationId,
    this.categoryId,
    this.description,
    this.quantityAvailable,
    this.expirationDate,
    this.status,
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  /// Whole-percent discount off [oldPrice], or null when not on offer.
  int? get discountPercent {
    final old = oldPrice;
    if (old == null || old <= 0 || old <= price) return null;
    return (((old - price) / old) * 100).round();
  }

  /// The exact response shape for `/marketplace/products` isn't documented,
  /// so common key spellings are all accepted — a mismatch shows up as a
  /// blank/default field rather than a crash.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString());
    }

    String? firstImage() {
      final images = json['images'] ?? json['imageUrls'] ?? json['photos'];
      if (images is List && images.isNotEmpty) {
        final first = images.first;
        if (first is String) return first;
        if (first is Map) return (first['imageUrl'] ?? first['url'])?.toString();
      }
      return null;
    }

    List<String> allImages() {
      final rawImages = json['images'] ?? json['imageUrls'] ?? json['photos'];
      if (rawImages is List) {
        return rawImages.map((img) {
          if (img is String) return img;
          if (img is Map) return (img['imageUrl'] ?? img['url'])?.toString() ?? '';
          return '';
        }).where((s) => s.isNotEmpty).toList();
      }
      final single = firstImage();
      return single != null ? [single] : [];
    }

    final quantity = toDouble(json['quantityAvailable'] ?? json['quantity'] ?? json['stock']);

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: (json['name'] ?? json['productName'] ?? json['title'] ?? '')
          .toString(),
      seller: (json['organizationName'] ??
              json['storeName'] ??
              json['sellerName'] ??
              json['seller'] ??
              json['ownerName'] ??
              '')
          .toString(),
      imageUrl:
          (json['imageUrl'] ?? json['image'] ?? firstImage() ?? '').toString(),
      price: toDouble(json['discountedPrice'] ?? json['price'] ?? json['unitPrice']) ?? 0,
      oldPrice: toDouble(
        json['originalPrice'] ?? json['oldPrice'] ?? json['comparePrice'],
      ),
      badge: json['categoryName']?.toString() ?? json['category']?.toString(),
      rating: toDouble(json['rating'] ?? json['averageRating']) ?? 4.7,
      reviews: toInt(json['reviewsCount'] ?? json['reviewCount']) ?? 0,
      inStock: json['inStock'] is bool
          ? json['inStock'] as bool
          : (quantity == null || quantity > 0),
      images: allImages(),
      organizationId: json['organizationId']?.toString(),
      categoryId: json['categoryId']?.toString(),
      description: json['description']?.toString(),
      quantityAvailable: toInt(json['quantityAvailable']),
      expirationDate: json['expirationDate']?.toString(),
      status: json['status']?.toString(),
      latitude: toDouble(json['latitude']),
      longitude: toDouble(json['longitude']),
      distanceKm: toDouble(json['distanceKm']),
    );
  }

  @override
  List<Object?> get props => [id, name, seller, price, oldPrice];
}
