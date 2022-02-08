import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';
import 'package:onde_gastei_app/app/modules/expenses/view_models/expenses_input_model.dart';

class ExpensesServicesImpl implements ExpensesServices {
  ExpensesServicesImpl({required ExpensesRepository repository})
      : _repository = repository;

  final ExpensesRepository _repository;

  @override
  Future<void> register(ExpensesInputModel expensesInputModel) =>
      _repository.register(expensesInputModel);

  @override
  Future<void> update(ExpensesInputModel expensesInputModel, int expenseId) =>
      _repository.update(expensesInputModel, expenseId);

  @override
  Future<void> delete(int expenseId) => _repository.delete(expenseId);
}
