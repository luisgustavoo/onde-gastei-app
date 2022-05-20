import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

enum HomeState { idle, loading, error, success }

class HomeControllerImpl extends ChangeNotifier implements HomeController {
  HomeControllerImpl({
    required HomeService service,
  }) : _service = service;

  final HomeService _service;

  List<TotalExpensesCategoriesViewModel> totalExpensesCategoriesList =
      <TotalExpensesCategoriesViewModel>[];
  List<PercentageCategoriesViewModel> percentageCategoriesList =
      <PercentageCategoriesViewModel>[];
  HomeState state = HomeState.idle;

  double totalExpenses = 0;

  @override
  Future<void> fetchHomeData({
    required int userId,
    required DateTime initialDate,
    required DateTime finalDate,
  }) async {
    try {
      state = HomeState.loading;
      notifyListeners();

      totalExpensesCategoriesList = await _service
          .findTotalExpensesByCategories(userId, initialDate, finalDate);
      percentageCategoriesList = await _service.findPercentageByCategories(
        userId,
        initialDate,
        finalDate,
      );

      getTotalExpenses();

      state = HomeState.success;
      notifyListeners();
    } on Exception {
      state = HomeState.error;
      notifyListeners();

      throw Failure(message: 'Erro ao buscar dados da home page');
    }
  }

  double getTotalExpenses() {
    totalExpenses = 0;

    totalExpensesCategoriesList.fold<double>(
      0,
      (previousValue, expensesCategories) =>
          totalExpenses += expensesCategories.totalValue,
    );

    return totalExpenses;
  }
}
