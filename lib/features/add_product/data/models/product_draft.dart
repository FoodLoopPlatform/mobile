import 'dart:io';

import 'package:foodloop/features/add_product/data/models/category_model.dart';

/// Step 1's answers, carried into the later steps of the wizard.
///
/// Nothing is sent to the API until the wizard finishes, so this stays a plain
/// in-memory object rather than a request body.
class ProductDraft {
  final String name;
  final CategoryModel? category;
  final String price;
  final int quantity;
  final String description;
  final List<File> photos;

  const ProductDraft({
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
    required this.description,
    this.photos = const [],
  });
}
