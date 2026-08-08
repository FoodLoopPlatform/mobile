import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/features/add_product/data/repositories/category_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryCubit(this._categoryRepository) : super(const CategoryInitial());

  Future<void> loadCategories({bool forceRefresh = false}) async {
    emit(const CategoryLoading());
    try {
      final categories = await _categoryRepository.getCategories(
        forceRefresh: forceRefresh,
      );
      emit(CategoryLoaded(categories: categories));
    } on Errors catch (e) {
      emit(CategoryFail(message: e.errMessage));
    } catch (e) {
      emit(CategoryFail(message: e.toString()));
    }
  }
}
