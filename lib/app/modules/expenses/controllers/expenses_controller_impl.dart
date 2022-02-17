import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';

enum expensesState { idle, loading, error, success }

class ExpensesControllerImpl extends ChangeNotifier
    implements ExpensesController {
  ExpensesControllerImpl({
    required ExpensesServices services,
    required Log log,
  })  : _services = services,
        _log = log;

  final ExpensesServices _services;
  final Log _log;
  expensesState state = expensesState.idle;

  @override
  Future<void> register({
    required String description,
    required double value,
    required DateTime date,
    required CategoryModel category,
    int? userId,
  }) async {
    try {
      state = expensesState.loading;
      notifyListeners();

      final expenseModel = ExpenseModel(
        description: description,
        value: value,
        date: date,
        category: category,
        userId: userId,
      );

      await _services.register(expenseModel);

      state = expensesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao registrar despesa', e, s);

      state = expensesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> update({
    required String description,
    required double value,
    required DateTime date,
    required CategoryModel category,
    required int expenseId,
    int? userId,
  }) async {
    try {
      state = expensesState.loading;
      notifyListeners();

      final expenseModel = ExpenseModel(
        description: description,
        value: value,
        date: date,
        category: category,
        userId: userId,
      );

      await _services.update(expenseModel, expenseId);

      state = expensesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao atualizar despesa', e, s);

      state = expensesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> delete({required int expenseId}) async {
    try {
      state = expensesState.loading;
      notifyListeners();

      await _services.delete(expenseId);

      state = expensesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao deletar despesa', e, s);

      state = expensesState.error;
      notifyListeners();

      throw Failure();
    }
  }
}
