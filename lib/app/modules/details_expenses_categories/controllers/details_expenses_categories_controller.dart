import 'package:onde_gastei_app/app/models/expense_model.dart';

abstract class DetailsExpensesCategoriesController {
  Future<List<ExpenseModel>> findExpensesByCategories(
      int userId,
      int categoryId,
      DateTime initialDate,
      DateTime finalDate,
      );
}
