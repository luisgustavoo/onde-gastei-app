import 'package:onde_gastei_app/app/models/category_model.dart';

abstract class ExpensesController {
  Future<void> register({
    required String description,
    required double value,
    required DateTime date,
    required CategoryModel category,
    int? userId,
  });

  Future<void> update({
    required String description,
    required double value,
    required DateTime date,
    required CategoryModel category,
    required int expenseId,
    int? userId,
  });

  Future<void> delete({required int expenseId});

  Future<void> findExpensesByPeriod({
    required int userId,
    required DateTime initialDate,
    required DateTime finalDate,
  });

  void filterExpensesList(String description);

  void sortExpenseList(int orderNumber);
}
