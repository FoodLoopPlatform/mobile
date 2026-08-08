import 'package:equatable/equatable.dart';
import 'package:foodloop/features/add_product/data/models/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  const CategoryLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoryFail extends CategoryState {
  final String message;
  const CategoryFail({required this.message});

  @override
  List<Object?> get props => [message];
}
