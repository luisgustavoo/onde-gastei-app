class ExpensesInputModel {
  ExpensesInputModel({
    required this.description,
    required this.value,
    required this.date,
    required this.categoryId,
    this.userId,
  });

  final String description;
  final double value;
  final DateTime date;
  final int? userId;
  final int categoryId;

}
