import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/exceptions/expenses_exists_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

enum CategoriesState { idle, loading, error, success }

enum CategoriesDeleteState { idle, loading, error, success }

class CategoriesControllerImpl extends ChangeNotifier
    implements CategoriesController {
  CategoriesControllerImpl({
    required CategoriesService service,
    required Log log,
  })  : _service = service,
        _log = log;

  final CategoriesService _service;
  final Log _log;
  List<CategoryModel> categoriesList = <CategoryModel>[];

  // CategoryModel? _category;

  // CategoryModel? get category => _category;

  // set category(CategoryModel? categoryModel) {
  //   _category = categoryModel;
  //   notifyListeners();
  // }

  CategoriesState state = CategoriesState.idle;
  CategoriesDeleteState stateDelete = CategoriesDeleteState.idle;

  @override
  Future<void> register(CategoryModel categoryModel) async {
    try {
      state = CategoriesState.loading;
      notifyListeners();

      await _service.register(categoryModel);

      // categoriesList.add(categoryModel);

      state = CategoriesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao registrar categoria', e, s);

      state = CategoriesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> updateCategory(
    int categoryId,
    CategoryInputModel categoryInputModel,
  ) async {
    try {
      state = CategoriesState.loading;
      notifyListeners();

      await _service.updateCategory(categoryId, categoryInputModel);

      // categoriesList[categoriesList
      //     .indexWhere((element) => element.id == categoryId)] = CategoryModel(
      //   id: categoryInputModel.id,
      //   description: categoryInputModel.description,
      //   iconCode: categoryInputModel.iconCode,
      //   colorCode: categoryInputModel.colorCode,
      // );

      state = CategoriesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao atualizar categoria', e, s);

      state = CategoriesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    try {
      stateDelete = CategoriesDeleteState.loading;
      notifyListeners();

      final quantity = await _service.expenseQuantityByCategoryId(categoryId);

      if (quantity > 0) {
        throw ExpensesExistsException();
      }

      await _service.deleteCategory(categoryId);

      // categoriesList.removeAt(
      //   categoriesList.indexWhere((element) => element.id == categoryId),
      // );

      stateDelete = CategoriesDeleteState.success;
      notifyListeners();
    } on ExpensesExistsException {
      stateDelete = CategoriesDeleteState.error;
      notifyListeners();
      rethrow;
    } on Exception catch (e, s) {
      _log.error('Erro ao excluir categoria', e, s);

      stateDelete = CategoriesDeleteState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> findCategories(int userId) async {
    try {
      state = CategoriesState.loading;
      notifyListeners();

      categoriesList = await _service.findCategories(userId);

      state = CategoriesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar categorias', e, s);

      state = CategoriesState.error;
      notifyListeners();

      throw Failure();
    }
  }
}
