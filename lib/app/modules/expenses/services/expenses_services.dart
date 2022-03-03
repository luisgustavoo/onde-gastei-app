import 'package:onde_gastei_app/app/models/expense_model.dart';

abstract class ExpensesServices {
  Future<void> register(ExpenseModel expenseModel);

  Future<void> update(ExpenseModel expenseModel, int expenseId);

  Future<void> delete(int expenseId);

  Future<List<ExpenseModel>> findExpensesByPeriod(
    DateTime initialDate,
    DateTime finalDate,
    int userId,
  );
}
