import 'package:equatable/equatable.dart';

/// A market product. Static/demo for now — shape it toward the real listings
/// API when the market endpoint lands.
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
  });

  /// Whole-percent discount off [oldPrice], or null when not on offer.
  int? get discountPercent {
    final old = oldPrice;
    if (old == null || old <= 0 || old <= price) return null;
    return (((old - price) / old) * 100).round();
  }

  @override
  List<Object?> get props => [id, name, seller, price, oldPrice];
}
