import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';

class ExpensesServicesImpl implements ExpensesServices {
  ExpensesServicesImpl({required ExpensesRepository repository})
      : _repository = repository;

  final ExpensesRepository _repository;

  @override
  Future<void> register(ExpenseModel expenseModel) =>
      _repository.register(expenseModel);

  @override
  Future<void> update(ExpenseModel expenseModel, int expenseId) =>
      _repository.update(expenseModel, expenseId);

  @override
  Future<void> delete(int expenseId) => _repository.delete(expenseId);
}
