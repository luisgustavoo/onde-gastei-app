// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:onde_gastei_app/app/models/category_model.dart';

class TotalExpensesCategoriesViewModel {
  TotalExpensesCategoriesViewModel(
      {required this.totalValue, required this.category});

  factory TotalExpensesCategoriesViewModel.fromMap(Map<String, dynamic> map) {
    return TotalExpensesCategoriesViewModel(
      totalValue: double.parse(map['valor_total'].toString()),
      category: CategoryModel.fromMap(map['categoria'] as Map<String, dynamic>),
    );
  }

  final double totalValue;
  final CategoryModel category;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'valor_total': totalValue,
      'categoria': category.toMap(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TotalExpensesCategoriesViewModel &&
          runtimeType == other.runtimeType &&
          totalValue == other.totalValue &&
          category == other.category;

  @override
  int get hashCode => totalValue.hashCode ^ category.hashCode;
}
