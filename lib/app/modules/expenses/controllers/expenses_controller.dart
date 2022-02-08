abstract class ExpensesController {
  Future<void> register({
    required String description,
    required double value,
    required DateTime date,
    required int categoryId,
    int? userId,
  });

  Future<void> update({
    required String description,
    required double value,
    required DateTime date,
    required int categoryId,
    required int expenseId,
    int? userId,
  });

  Future<void> delete({required int expenseId});
}
