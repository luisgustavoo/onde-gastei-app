import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/repositories/details_expenses_categories_repository.dart';

class DetailsExpensesCategoriesRepositoryImpl
    implements DetailsExpensesCategoriesRepository {
  DetailsExpensesCategoriesRepositoryImpl({
    required RestClient restClient,
    required Log log,
  })  : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  @override
  Future<List<ExpenseModel>> findExpensesByCategories(
    int userId,
    int categoryId,
    DateTime initialDate,
    DateTime finalDate,
  ) async {
    try {
      final result = await _restClient.get<List<dynamic>>(
        '/users/$userId/expenses/categories/$categoryId',
        queryParameters: <String, dynamic>{
          'initial_date': initialDate.toIso8601String(),
          'final_date': finalDate.toIso8601String(),
        },
      );

      if (result.data != null) {
        final expensesListCategories =
            List<Map<String, dynamic>>.from(result.data!);
        return expensesListCategories.map(ExpenseModel.fromMap).toList();
      }

      return <ExpenseModel>[];
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar despesas por categoria', e, s);
      throw Failure();
    }
  }
}
