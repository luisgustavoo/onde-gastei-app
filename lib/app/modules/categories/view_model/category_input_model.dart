
import 'package:flutter/foundation.dart';

@immutable
class CategoryInputModel {
  const CategoryInputModel({
    required this.description,
    required this.iconCode,
    required this.colorCode,
    this.id,
  });

  final int? id;
  final String description;
  final int iconCode;
  final int colorCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryInputModel &&
          runtimeType == other.runtimeType &&
          description == other.description &&
          iconCode == other.iconCode &&
          colorCode == other.colorCode);

  @override
  int get hashCode =>
      description.hashCode ^ iconCode.hashCode ^ colorCode.hashCode;
}
