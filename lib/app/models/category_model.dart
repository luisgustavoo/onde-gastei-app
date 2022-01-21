// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

class CategoryModel {
  const CategoryModel({
    required this.description,
    required this.iconCode,
    required this.colorCode,
    this.id,
    this.userId,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: int.parse(map['id_categoria'].toString()),
      description: map['descricao'].toString(),
      iconCode: int.parse(map['codigo_icone'].toString()),
      colorCode: int.parse(map['codigo_cor'].toString()),
      userId: map['id_usuario'] as int?,
    );
  }

  final int? id;
  final String description;
  final int iconCode;
  final int colorCode;
  final int? userId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_categoria': id,
      'descricao': description,
      'codigo_icone': iconCode,
      'codigo_cor': colorCode,
      'id_usuario': userId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          description == other.description &&
          iconCode == other.iconCode &&
          colorCode == other.colorCode &&
          userId == other.userId);

  @override
  int get hashCode =>
      id.hashCode ^
      description.hashCode ^
      iconCode.hashCode ^
      colorCode.hashCode ^
      userId.hashCode;
}
