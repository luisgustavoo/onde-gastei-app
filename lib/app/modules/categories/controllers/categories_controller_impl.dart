import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

enum categoriesState { idle, loading, error, success }

class CategoriesControllerImpl extends ChangeNotifier
    implements CategoriesController {
  CategoriesControllerImpl(
      {required CategoriesService service, required Log log})
      : _service = service,
        _log = log;

  final CategoriesService _service;
  final Log _log;
  List<CategoryModel> categoriesList = <CategoryModel>[];

  categoriesState state = categoriesState.idle;

  @override
  Future<void> register(CategoryModel categoryModel) async {
    try {
      state = categoriesState.loading;
      notifyListeners();

      await _service.register(categoryModel);

      state = categoriesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao registrar categoria', e, s);

      state = categoriesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> updateCategory(
      int categoryId, CategoryInputModel categoryInputModel) async {
    try {
      state = categoriesState.loading;
      notifyListeners();

      await _service.updateCategory(categoryId, categoryInputModel);

      state = categoriesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao atualizar categoria', e, s);

      state = categoriesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    try {
      state = categoriesState.loading;
      notifyListeners();

      await _service.deleteCategory(categoryId);

      state = categoriesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao excluir categoria', e, s);

      state = categoriesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> findCategories(int userId) async {
    try {
      state = categoriesState.loading;
      notifyListeners();

      categoriesList = await _service.findCategories(userId);

      state = categoriesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar categorias', e, s);

      state = categoriesState.error;
      notifyListeners();

      throw Failure();
    }
  }
}
