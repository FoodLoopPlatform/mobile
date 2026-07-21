class BusinessDetailsModel {
  String? governorate;
  String? city;
  String? neighborhood;
  String? street;
  double? latitude;
  double? longitude;

  // Document paths (local file paths before upload)
  String? taxIdDocumentPath;
  String? commercialRegDocumentPath;
  String? healthCertDocumentPath;

  BusinessDetailsModel({
    this.governorate,
    this.city,
    this.neighborhood,
    this.street,
    this.latitude,
    this.longitude,
    this.taxIdDocumentPath,
    this.commercialRegDocumentPath,
    this.healthCertDocumentPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'governorate': governorate,
      'city': city,
      'neighborhood': neighborhood,
      'street': street,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  bool get isLocationComplete =>
      governorate != null &&
      governorate!.isNotEmpty &&
      city != null &&
      city!.isNotEmpty;
}
