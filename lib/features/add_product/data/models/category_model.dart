import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;

  const CategoryModel({required this.id, required this.name});

  /// Key names aren't documented for `/categories`, so the common spellings
  /// are all accepted — a mismatch shows up as a blank label rather than a
  /// crash.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['nameAr'] ??
          json['name'] ??
          json['title'] ??
          json['nameEn'] ??
          '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
