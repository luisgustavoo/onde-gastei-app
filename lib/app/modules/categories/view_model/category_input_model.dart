// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

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
