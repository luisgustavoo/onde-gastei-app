import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';
import 'package:onde_gastei_app/app/modules/expenses/view_models/expenses_input_model.dart';

class ExpensesControllerImpl extends ChangeNotifier
    implements ExpensesController {
  ExpensesControllerImpl({
    required ExpensesServices services,
    required Log log,
  })  : _services = services,
        _log = log;

  final ExpensesServices _services;
  final Log _log;

  @override
  Future<void> register({
    required String description,
    required double value,
    required DateTime date,
    required int categoryId,
    int? userId,
  }) async {
    try {
      final expensesInputModel = ExpensesInputModel(
        description: description,
        value: value,
        date: date,
        categoryId: categoryId,
        userId: userId,
      );

      await _services.register(expensesInputModel);
    } on Exception catch (e, s) {
      _log.error('Erro ao registrar despesa', e, s);
      throw Failure();
    }
  }

  @override
  Future<void> update({
    required String description,
    required double value,
    required DateTime date,
    required int categoryId,
    required int expenseId,
    int? userId,
  }) async {
    try {
      final expensesInputModel = ExpensesInputModel(
        description: description,
        value: value,
        date: date,
        categoryId: categoryId,
        userId: userId,
      );

      await _services.update(expensesInputModel, expenseId);
    } on Exception catch (e, s) {
      _log.error('Erro ao atualizar despesa', e, s);
      throw Failure();
    }
  }

  @override
  Future<void> delete({required int expenseId}) async {
    try {
      await _services.delete(expenseId);
    } on Exception catch (e, s) {
      _log.error('Erro ao deletar despesa', e, s);
      throw Failure();
    }
  }
}
