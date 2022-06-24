import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';

class AppController extends ChangeNotifier {
  AppController({
    required this.homeController,
    required this.categoriesController,
    required this.expensesController,
    required this.userController,
    required this.localStorage,
  });

  final HomeController homeController;
  final CategoriesController categoriesController;
  final ExpensesController expensesController;
  final UserController userController;
  final LocalStorage localStorage;
  bool isDark = false;

  int _tabIndex = 0;

  set tabIndex(int index) {
    if (index >= 0) {
      _tabIndex = index;
      notifyListeners();
    }
  }

  Future<bool> getDarkTheme() async {
    isDark = await localStorage.read<bool>(Constants.darkThemeKey) ?? false;
    notifyListeners();
    return isDark;
  }

  void toggleTheme({required bool value}) {
    isDark = value;
    localStorage.write<bool>(Constants.darkThemeKey, value);
    notifyListeners();
  }

  int get tabIndex => _tabIndex;

  Future<void> fetchUserData() => userController.fetchUserData();

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
        userId: userId,
        initialDate: initialDate,
        finalDate: finalDate,
      );
}
