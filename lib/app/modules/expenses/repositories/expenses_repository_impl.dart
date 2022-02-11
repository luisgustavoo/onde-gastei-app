import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository.dart';
import 'package:onde_gastei_app/app/modules/expenses/view_models/expenses_input_model.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl({required RestClient restClient, required Log log})
      : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  @override
  Future<void> register(ExpenseModel expenseModel) async {
    try {
      await _restClient.auth().post(
        '/expenses/register',
        data: <String, dynamic>{
          'descricao': expenseModel.description,
          'valor': expenseModel.value,
          'data': expenseModel.date,
          'id_usuario': expenseModel.userId,
          'id_categoria': expenseModel.categoryId
        },
      );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao registrar despesa', e, s);
      throw Failure();
    }
  }

  @override
  Future<void> update(
    ExpenseModel expenseModel,
    int expenseId,
  ) async {
    try {
      await _restClient.auth().put(
        '/expenses/$expenseId/update',
        data: <String, dynamic>{
          'descricao': expenseModel.description,
          'valor': expenseModel.value,
          'data': expenseModel.date,
          'id_categoria': expenseModel.categoryId
        },
      );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao atualizar despesa', e, s);
      throw Failure();
    }
  }

  @override
  Future<void> delete(int expenseId) async {
    try {
      await _restClient.auth().delete<Map<String, dynamic>>(
            '/expenses/$expenseId/delete',
          );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao deletar despesa', e, s);
      throw Failure();
    }
  }
}