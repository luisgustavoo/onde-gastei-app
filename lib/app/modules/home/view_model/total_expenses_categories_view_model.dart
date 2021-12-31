class TotalExpensesCategoriesViewModel {
  TotalExpensesCategoriesViewModel({
    required this.categoryId,
    required this.categoryDescription,
    required this.totalValue,
  });

  factory TotalExpensesCategoriesViewModel.fromMap(Map<String, dynamic> map) {
    return TotalExpensesCategoriesViewModel(
      categoryId: int.parse(map['id_categoria'].toString()),
      categoryDescription: map['descricao'].toString(),
      totalValue: double.parse(map['valor_total'].toString()),
    );
  }

  final int categoryId;
  final String categoryDescription;
  final double totalValue;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'categoryDescription': categoryDescription,
      'totalValue': totalValue,
    };
  }
}
