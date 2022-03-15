import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';

class AppController extends ChangeNotifier {
  AppController({
    required this.homeController,
    required this.categoriesController,
    required this.expensesController,
  });

  final HomeController homeController;
  final CategoriesController categoriesController;
  final ExpensesController expensesController;

  int _tabIndex = 0;

  set tabIndex(int index) {
    if (index >= 0) {
      _tabIndex = index;
      notifyListeners();
    }
  }

  int get tabIndex => _tabIndex;

  Future<void> findCategories(int userId) =>
      categoriesController.findCategories(userId);

  Future<void> fetchHomeData({
    required int userId,
    required DateTime initialDate,
    required DateTime finalDate,
  }) =>
      homeController.fetchHomeData(
        userId: userId,
        initialDate: initialDate,
        finalDate: finalDate,
      );

  Future<void> findExpenses(
    DateTime initialDate,
    DateTime finalDate,
    int userId,
  ) =>
      expensesController.findExpensesByPeriod(
          userId: userId, initialDate: initialDate, finalDate: finalDate);
}
