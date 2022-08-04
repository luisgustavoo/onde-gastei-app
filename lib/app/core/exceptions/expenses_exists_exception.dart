class ExpensesExistsException implements Exception {
  ExpensesExistsException({this.message});

  final String? message;
}
