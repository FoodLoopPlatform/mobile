import 'dart:io';
import 'package:foodloop/features/add_product/data/data_sources/add_product_remote_data_source.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';

class AddProductRepository {
  final AddProductRemoteDataSource _remoteDataSource;

  AddProductRepository(this._remoteDataSource);

  Future<void> publishProducts({
    required ProductDraft draft,
    required List<ExpirationBatch> batches,
  }) async {
    final double price = double.tryParse(draft.price) ?? 0.0;

    for (var batch in batches) {
      // Format date to YYYY-MM-DD
      final String formattedDate =
          "${batch.date.year.toString().padLeft(4, '0')}-${batch.date.month.toString().padLeft(2, '0')}-${batch.date.day.toString().padLeft(2, '0')}";

      final String expiryVerificationState = batch.confidenceScore >= .85
          ? 'AiVerified'
          : 'AiLowConfidence';

      // 1. Create the product
      final productId = await _remoteDataSource.addProduct(
        categoryId: draft.category?.id ?? '',
        title: draft.name,
        description: draft.description,
        originalPrice: price,
        discountedPrice: price, // Same as original price as requested
        quantityAvailable: batch.quantity,
        expirationDate: formattedDate,
        confidenceScore: batch.confidenceScore,
        expiryVerificationState: expiryVerificationState,
        extractedText: batch.extractedText,
      );

      // 2. Upload images for this product
      // Collect all images: draft photos + batch photo
      final List<File> photosToUpload = List.from(draft.photos);
      if (batch.photo != null) {
        photosToUpload.add(batch.photo!);
      }

      // Loop on the photos and upload them all
      for (var photo in photosToUpload) {
        await _remoteDataSource.uploadProductImage(productId, photo);
      }
    }
  }
}
