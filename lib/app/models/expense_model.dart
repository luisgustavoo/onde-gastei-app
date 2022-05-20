import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';

@immutable
class ExpenseModel {
  const ExpenseModel({
    required this.description,
    required this.value,
    required this.date,
    required this.category,
    this.userId,
    this.expenseId,
    this.local,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      expenseId: int.parse(map['id_despesa'].toString()),
      description: map['descricao'].toString(),
      value: double.parse(map['valor'].toString()),
      date: DateTime.parse(map['data'].toString()),
      local: map['local'].toString(),
      category: CategoryModel.fromMap(map['categoria'] as Map<String, dynamic>),
    );
  }

  final int? expenseId;
  final String description;
  final double value;
  final DateTime date;
  final String? local;
  final CategoryModel category;
  final int? userId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_despesa': expenseId,
      'descricao': description,
      'valor': value,
      'data': date,
      'local': local,
      'category': category.toMap(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModel &&
          runtimeType == other.runtimeType &&
          expenseId == other.expenseId &&
          description == other.description &&
          value == other.value &&
          date == other.date &&
          local == other.local &&
          category == other.category &&
          userId == other.userId;

  @override
  int get hashCode =>
      expenseId.hashCode ^
      description.hashCode ^
      value.hashCode ^
      date.hashCode ^
      local.hashCode ^
      category.hashCode ^
      userId.hashCode;
}
