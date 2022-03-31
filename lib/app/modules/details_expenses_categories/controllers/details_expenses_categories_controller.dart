import 'package:onde_gastei_app/app/models/expense_model.dart';

abstract class DetailsExpensesCategoriesController {
  Future<List<ExpenseModel>> findExpensesByCategories({
    required int userId,
    required int categoryId,
    required DateTime initialDate,
    required DateTime finalDate,
  });
}
