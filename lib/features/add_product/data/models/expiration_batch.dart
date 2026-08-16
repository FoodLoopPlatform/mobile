import 'dart:io';

/// An immutable snapshot of one expiry batch, handed from step 2 to step 3.
class ExpirationBatch {
  final DateTime date;
  final int quantity;
  final File? photo;

  /// OCR confidence score for this batch's expiry date.
  /// 0.0 if the product was published without OCR, or if OCR failed/returned a past date.
  final double confidenceScore;

  /// Raw text extracted from the OCR scan (if available).
  final String? extractedText;

  const ExpirationBatch({
    required this.date,
    required this.quantity,
    this.photo,
    this.confidenceScore = 0.0,
    this.extractedText,
  });

  ExpirationBatch copyWith({
    DateTime? date,
    int? quantity,
    File? photo,
    double? confidenceScore,
    String? extractedText,
  }) {
    return ExpirationBatch(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      photo: photo ?? this.photo,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      extractedText: extractedText ?? this.extractedText,
    );
  }
}
