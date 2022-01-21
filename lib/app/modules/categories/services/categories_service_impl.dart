import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

class CategoriesServiceImpl implements CategoriesService {
  CategoriesServiceImpl({required CategoriesRepository repository})
      : _repository = repository;

  final CategoriesRepository _repository;

  @override
  Future<void> register(CategoryModel categoryModel) =>
      _repository.register(categoryModel);

  @override
  Future<void> updateCategory(
          int categoryId, CategoryInputModel categoryInputModel) =>
      _repository.updateCategory(categoryId, categoryInputModel);

  @override
  Future<void> deleteCategory(int categoryId) =>
      _repository.deleteCategory(categoryId);

  @override
  Future<List<CategoryModel>> findCategories(int userId) =>
      _repository.findCategories(userId);
}
