import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';

/// Hardcoded demo catalogue backing the static Market screen. Replace with the
/// listings API response when it's wired up.
abstract class SampleProducts {
  // Remote images degrade gracefully to a placeholder icon if they fail.
  static const String _img1 =
      'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600';
  static const String _img2 =
      'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600';
  static const String _img3 =
      'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=600';
  static const String _img4 =
      'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=600';
  static const String _img5 =
      'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=600';
  static const String _img6 =
      'https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=600';

  static const List<ProductModel> recommended = [
    ProductModel(
      id: 'rec-1',
      name: 'باقة الحصاد الموسمي',
      seller: 'من مزارع جرين فالي',
      imageUrl: _img1,
      price: 24.00,
      oldPrice: 46.00,
      badge: 'عضوي',
    ),
    ProductModel(
      id: 'rec-2',
      name: 'رغيف خبز العجين المخمّر',
      seller: 'مخبز الخميرة البرية',
      imageUrl: _img2,
      price: 8.50,
      badge: AppStrings.categoryBakery,
    ),
  ];

  static const List<ProductModel> nearbyDeals = [
    ProductModel(
      id: 'deal-1',
      name: 'عنب عضوي',
      seller: 'سوق المدينة',
      imageUrl: _img3,
      price: 3.50,
      oldPrice: 5.99,
      countdown: '04:03:56',
    ),
    ProductModel(
      id: 'deal-2',
      name: 'طبق سلمون',
      seller: 'مطبخ بيور',
      imageUrl: _img4,
      price: 11.20,
      oldPrice: 14.95,
      countdown: '01:36:11',
    ),
    ProductModel(
      id: 'deal-3',
      name: 'باقة موز',
      seller: 'بقالة يومية',
      imageUrl: _img5,
      price: 1.25,
      oldPrice: 2.50,
      countdown: '00:13:16',
    ),
  ];

  static const List<ProductModel> trending = [
    ProductModel(
      id: 'trend-1',
      name: 'توت مشكّل',
      seller: 'سوق المدينة',
      imageUrl: _img6,
      price: 6.00,
      tagline: 'الأفضل هذا الأسبوع',
    ),
    ProductModel(
      id: 'trend-2',
      name: 'باستا بيستو',
      seller: 'مطبخ بيور',
      imageUrl: _img4,
      price: 9.50,
      tagline: '42 طلب اليوم',
    ),
    ProductModel(
      id: 'trend-3',
      name: 'جرين بوست',
      seller: 'عصائر طازجة',
      imageUrl: _img3,
      price: 4.25,
      tagline: 'عصير محلي رائج',
    ),
    ProductModel(
      id: 'trend-4',
      name: 'شوكولاتة بملح البحر',
      seller: 'حلويات محلية',
      imageUrl: _img2,
      price: 5.75,
      tagline: 'دفعة محدودة',
    ),
  ];
}
