import 'package:dio/dio.dart';
import '../../../../core/errors/errors.dart';
import '../data_sources/category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepository(this._remoteDataSource);

  List<CategoryModel>? _cached;

  /// Categories rarely change, so they're fetched once per session.
  Future<List<CategoryModel>> getCategories({bool forceRefresh = false}) async {
    if (_cached != null && !forceRefresh) return _cached!;
    try {
      _cached = await _remoteDataSource.getCategories();
      return _cached!;
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is Errors) rethrow;
      throw ServerError('Unknown error occurred');
    }
  }
}
