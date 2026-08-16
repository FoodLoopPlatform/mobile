/// Response from the OCR scan endpoint: /stores/me/products/ocr-scan
class OcrScanResponse {
  final String productId;
  final String detectedProduct;
  final String suggestedDescription;
  final String suggestedCategory;
  final String? suggestedCategoryId;
  final double confidenceScore;
  final DateTime? extractedExpiryDate;
  final String extractedText;
  final bool reviewed;

  const OcrScanResponse({
    required this.productId,
    required this.detectedProduct,
    required this.suggestedDescription,
    required this.suggestedCategory,
    this.suggestedCategoryId,
    required this.confidenceScore,
    this.extractedExpiryDate,
    required this.extractedText,
    required this.reviewed,
  });

  factory OcrScanResponse.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final rawDate = json['extractedExpiryDate'] as String?;
    if (rawDate != null && rawDate.isNotEmpty) {
      parsedDate = DateTime.tryParse(rawDate);
    }

    return OcrScanResponse(
      productId: json['productId'] as String? ?? '',
      detectedProduct: json['detectedProduct'] as String? ?? '',
      suggestedDescription: json['suggestedDescription'] as String? ?? '',
      suggestedCategory: json['suggestedCategory'] as String? ?? '',
      suggestedCategoryId: json['suggestedCategoryId'] as String?,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      extractedExpiryDate: parsedDate,
      extractedText: json['extractedText'] as String? ?? '',
      reviewed: json['reviewed'] as bool? ?? false,
    );
  }
}
