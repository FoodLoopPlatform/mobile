import 'package:equatable/equatable.dart';

enum AddressType {
  home,
  company,
  other;

  static AddressType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'company':
        return AddressType.company;
      case 'other':
        return AddressType.other;
      case 'home':
      default:
        return AddressType.home;
    }
  }

  String toJson() {
    switch (this) {
      case AddressType.home:
        return 'Home';
      case AddressType.company:
        return 'Company';
      case AddressType.other:
        return 'Other';
    }
  }
}

class AddressModel extends Equatable {
  final String id;
  final AddressType addressType;
  final String city;
  final String district;
  final String street;
  final String? buildingNo;
  final String? floor;
  final String? apartmentNo;
  final String? notes;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const AddressModel({
    this.id = '',
    this.addressType = AddressType.home,
    required this.city,
    required this.district,
    required this.street,
    this.buildingNo,
    this.floor,
    this.apartmentNo,
    this.notes,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      addressType: AddressType.fromString(json['addressType']?.toString()),
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      street: json['street'] ?? '',
      buildingNo: json['buildingNo'],
      floor: json['floor'],
      apartmentNo: json['apartmentNo'],
      notes: json['notes'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['isDefault'] ?? false,
    );
  }

  /// Body for `POST /users/me/addresses` — city, district and street are required.
  Map<String, dynamic> toCreateJson() {
    return {
      'addressType': addressType.toJson(),
      'city': city,
      'district': district,
      'street': street,
      if (buildingNo != null) 'buildingNo': buildingNo,
      if (floor != null) 'floor': floor,
      if (apartmentNo != null) 'apartmentNo': apartmentNo,
      if (notes != null) 'notes': notes,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  AddressModel copyWith({
    AddressType? addressType,
    String? city,
    String? district,
    String? street,
    String? buildingNo,
    String? floor,
    String? apartmentNo,
    String? notes,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id,
      addressType: addressType ?? this.addressType,
      city: city ?? this.city,
      district: district ?? this.district,
      street: street ?? this.street,
      buildingNo: buildingNo ?? this.buildingNo,
      floor: floor ?? this.floor,
      apartmentNo: apartmentNo ?? this.apartmentNo,
      notes: notes ?? this.notes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [
        id,
        addressType,
        city,
        district,
        street,
        buildingNo,
        floor,
        apartmentNo,
        notes,
        latitude,
        longitude,
        isDefault,
      ];
}
