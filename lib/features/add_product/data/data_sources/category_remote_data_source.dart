import '../../../../core/api_helper/api_constants.dart';
import '../../../../core/api_helper/api_manager.dart';
import '../../../../core/api_helper/api_response.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiManager _apiManager;

  CategoryRemoteDataSource(this._apiManager);

  Future<List<CategoryModel>> getCategories() async {
    final response = await _apiManager.get(ApiConstants.categoriesEndpoint);
    return _parseCategories(response.data);
  }

  /// `/categories` may answer with a bare array or with the usual
  /// `{success, data}` envelope — both are accepted so the screen works
  /// either way.
  List<CategoryModel> _parseCategories(dynamic body) {
    if (body is List) return _mapList(body);

    if (body is Map<String, dynamic>) {
      final parsed = ApiResponse<List<CategoryModel>>.fromJson(
        body,
        (json) => _mapList(json),
      );
      if (!parsed.success) throw ServerError(parsed.errorMessage);
      return parsed.data ?? const [];
    }

    throw ServerError(AppStrings.errorUnexpectedResponse);
  }

  List<CategoryModel> _mapList(dynamic json) {
    if (json is! List) return const [];
    return json
        .whereType<Map<String, dynamic>>()
        .map(CategoryModel.fromJson)
        .toList(growable: false);
  }
}
