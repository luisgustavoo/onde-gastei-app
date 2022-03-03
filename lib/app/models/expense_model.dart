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

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      expenseId: int.parse(map['id_despesa'].toString()),
      description: map['descricao'].toString(),
      value: double.parse(map['valor'].toString()),
      date: DateTime.parse(map['data'].toString()),
      category: CategoryModel.fromMap(map['categoria'] as Map<String, dynamic>),
    );
  }

  final int? expenseId;
  final String description;
  final double value;
  final DateTime date;
  final CategoryModel category;
  final int? userId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_despesa': expenseId,
      'descricao': description,
      'valor': value,
      'data': date,
      'category': category.toMap(),
    };
  }
}
