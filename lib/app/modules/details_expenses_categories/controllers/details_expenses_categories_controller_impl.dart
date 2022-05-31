import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/controllers/details_expenses_categories_controller.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/services/details_expenses_categories_service.dart';

enum DetailsExpensesCategoriesState { idle, loading, error, success }

class DetailsExpensesCategoriesControllerImpl extends ChangeNotifier
    implements DetailsExpensesCategoriesController {
  DetailsExpensesCategoriesControllerImpl({
    required DetailsExpensesCategoriesService service,
    required Log log,
  })  : _service = service,
        _log = log;

  final DetailsExpensesCategoriesService _service;
  final Log _log;
  List<ExpenseModel> detailsExpensesCategoryList = <ExpenseModel>[];
  DetailsExpensesCategoriesState state = DetailsExpensesCategoriesState.idle;

  @override
  Future<List<ExpenseModel>> findExpensesByCategories({
    required int userId,
    required int categoryId,
    required DateTime initialDate,
    required DateTime finalDate,
  }) async {
    try {
      state = DetailsExpensesCategoriesState.loading;
      notifyListeners();

      detailsExpensesCategoryList = await _service.findExpensesByCategories(
        userId,
        categoryId,
        initialDate,
        finalDate,
      );

      state = DetailsExpensesCategoriesState.success;
      notifyListeners();
      return detailsExpensesCategoryList;
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar despesas or categoria', e, s);

      state = DetailsExpensesCategoriesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  double totalValueByDay(DateTime date) {
    final listDay = detailsExpensesCategoryList.where((e) => e.date == date);

    return listDay.fold<double>(
      0,
      (previousValue, expenses) => previousValue + expenses.value,
    );
  }
}
