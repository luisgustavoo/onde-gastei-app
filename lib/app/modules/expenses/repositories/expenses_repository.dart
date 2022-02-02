import 'package:onde_gastei_app/app/modules/expenses/view_models/expenses_input_model.dart';

abstract class ExpensesRepository {
  Future<void> register(ExpensesInputModel expensesInputModel);
  Future<void> update(ExpensesInputModel expensesInputModel, int expenseId);
}
