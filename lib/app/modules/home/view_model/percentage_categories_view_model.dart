class PercentageCategoriesViewModel {
  const PercentageCategoriesViewModel({
    required this.categoryId,
    required this.categoryDescription,
    required this.totalValueCategory,
    required this.categoryPercentage,
  });

  factory PercentageCategoriesViewModel.fromMap(Map<String, dynamic> map) {
    return PercentageCategoriesViewModel(
      categoryId: map['id_categoria'] as int,
      categoryDescription: map['descricao'] as String,
      totalValueCategory: map['valor_total_categoria'] as double,
      categoryPercentage: map['percentual_categoria'] as double,
    );
  }

  final int categoryId;
  final String categoryDescription;
  final double totalValueCategory;
  final double categoryPercentage;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_categoria': categoryId,
      'descricao': categoryDescription,
      'valor_total_categoria': totalValueCategory,
      'percentual_categoria': categoryPercentage,
    };
  }
}
