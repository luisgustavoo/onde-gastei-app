import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';

enum expensesState { idle, loading, error, success }

enum expensesDeleteState { idle, loading, error, success }

class ExpensesControllerImpl extends ChangeNotifier
    implements ExpensesController {
  ExpensesControllerImpl({
    required ExpensesServices services,
    required Log log,
  })  : _services = services,
        _log = log;

  final ExpensesServices _services;
  final Log _log;
  List<ExpenseModel> expensesList = <ExpenseModel>[];
  List<ExpenseModel> expensesListBeforeFilter = <ExpenseModel>[];
  expensesState state = expensesState.idle;
  expensesDeleteState deleteState = expensesDeleteState.idle;

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
      deleteState = expensesDeleteState.loading;
      notifyListeners();

      await _services.delete(expenseId);

      deleteState = expensesDeleteState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao deletar despesa', e, s);

      deleteState = expensesDeleteState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> findExpensesByPeriod({
    required int userId,
    required DateTime initialDate,
    required DateTime finalDate,
  }) async {
    try {
      state = expensesState.loading;
      notifyListeners();

      expensesList =
          await _services.findExpensesByPeriod(initialDate, finalDate, userId);

      expensesListBeforeFilter = expensesList;

      state = expensesState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar despesas', e, s);

      state = expensesState.error;
      notifyListeners();

      throw Failure();
    }
  }

  void filterExpensesList(String description) {
    expensesList = expensesListBeforeFilter;

    if (description.isNotEmpty) {
      expensesList = List<ExpenseModel>.from(
        expensesList.where(
          (expense) => expense.description.toLowerCase().contains(
                description.toLowerCase(),
              ),
        ),
      );
    }

    notifyListeners();
  }

  void orderByExpensesList(int orderNumber) {
    /* 
    1 = Maior Data
    2 = Menor Data
    3 = Maior Valor
    4 = Menor Valor  
    */

    switch (orderNumber) {
      case 1:
        expensesList.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 2:
        expensesList.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 3:
        expensesList.sort((a, b) => b.value.compareTo(a.value));
        break;
      case 4:
        expensesList.sort((a, b) => a.value.compareTo(b.value));
        break;
      default:
        expensesList.sort((a, b) => b.date.compareTo(a.date));
    }
    notifyListeners();
  }
}
