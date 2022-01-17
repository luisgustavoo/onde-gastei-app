// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

import 'package:onde_gastei_app/app/models/category_model.dart';

class PercentageCategoriesViewModel {
  const PercentageCategoriesViewModel({
    required this.value,
    required this.percentage,
    required this.category,
  });

  factory PercentageCategoriesViewModel.fromMap(Map<String, dynamic> map) {
    return PercentageCategoriesViewModel(
      value: double.parse(map['valor'].toString()),
      percentage: double.parse(map['percentual'].toString()),
      category: CategoryModel.fromMap(map['categoria'] as Map<String, dynamic>),
    );
  }

  final double value;
  final double percentage;
  final CategoryModel category;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'valor': value,
      'percentual': percentage,
      'categoria': category.toMap(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PercentageCategoriesViewModel &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          percentage == other.percentage &&
          category == other.category);

  @override
  int get hashCode => value.hashCode ^ percentage.hashCode ^ category.hashCode;
}
