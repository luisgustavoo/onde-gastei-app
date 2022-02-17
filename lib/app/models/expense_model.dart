import 'package:onde_gastei_app/app/models/category_model.dart';

class ExpenseModel {
  ExpenseModel({
    required this.description,
    required this.value,
    required this.date,
    required this.category,
    this.userId,
    this.expenseId,
  });

  final int? expenseId;
  final String description;
  final double value;
  final DateTime date;
  final CategoryModel category;
  final int? userId;
}
