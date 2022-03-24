import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/repositories/details_expenses_categories_repository.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/services/details_expenses_categories_service.dart';

class DetailsExpensesCategoriesServiceImpl
    implements DetailsExpensesCategoriesService {
  DetailsExpensesCategoriesServiceImpl(
      {required DetailsExpensesCategoriesRepository repository})
      : _repository = repository;

  final DetailsExpensesCategoriesRepository _repository;

  @override
  Future<List<ExpenseModel>> findExpensesByCategories(
    int userId,
    int categoryId,
    DateTime initialDate,
    DateTime finalDate,
  ) =>
      _repository.findExpensesByCategories(
        userId,
        categoryId,
        initialDate,
        finalDate,
      );
}
