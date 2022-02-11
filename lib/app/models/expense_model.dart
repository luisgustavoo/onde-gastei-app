class ExpenseModel {
  ExpenseModel({
    required this.description,
    required this.value,
    required this.date,
    required this.categoryId,
    this.userId,
    this.expenseId,
  });

  final int? expenseId;
  final String description;
  final double value;
  final DateTime date;
  final int categoryId;
  final int? userId;
}
