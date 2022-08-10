import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl({
    required RestClient restClient,
    required Log log,
    required MetricsMonitor metricsMonitor,
  })  : _restClient = restClient,
        _log = log,
        _metricsMonitor = metricsMonitor;

  final RestClient _restClient;
  final Log _log;
  final MetricsMonitor _metricsMonitor;

  @override
  Future<void> register(ExpenseModel expenseModel) async {
    final trace = _metricsMonitor.addTrace('register-expenses');
    try {
      await _metricsMonitor.startTrace(trace);
      await _restClient.auth().post<Map<String, dynamic>>(
        '/expenses/register',
        data: <String, dynamic>{
          'descricao': expenseModel.description,
          'valor': expenseModel.value,
          'data': expenseModel.date.toIso8601String(),
          'local': expenseModel.local,
          'id_usuario': expenseModel.userId,
          'id_categoria': expenseModel.category.id
        },
      );
      await _metricsMonitor.stopTrace(trace);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao registrar despesa', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<void> update(
    ExpenseModel expenseModel,
    int expenseId,
  ) async {
    final trace = _metricsMonitor.addTrace('update-expenses');
    try {
      await _metricsMonitor.startTrace(trace);
      await _restClient.auth().put(
        '/expenses/$expenseId/update',
        data: <String, dynamic>{
          'descricao': expenseModel.description,
          'valor': expenseModel.value,
          'data': expenseModel.date.toIso8601String(),
          'local': expenseModel.local,
          'id_categoria': expenseModel.category.id
        },
      );
      await _metricsMonitor.stopTrace(trace);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao atualizar despesa', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<void> delete(int expenseId) async {
    final trace = _metricsMonitor.addTrace('delete-expenses');
    try {
      await _metricsMonitor.startTrace(trace);
      await _restClient.auth().delete<Map<String, dynamic>>(
            '/expenses/$expenseId/delete',
          );
      await _metricsMonitor.stopTrace(trace);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao deletar despesa', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<List<ExpenseModel>> findExpensesByPeriod(
    DateTime initialDate,
    DateTime finalDate,
    int userId,
  ) async {
    final trace = _metricsMonitor.addTrace('find-expenses-by-period');
    try {
      await _metricsMonitor.startTrace(trace);
      final result = await _restClient.auth().get<List<dynamic>>(
        '/users/$userId/categories/period',
        queryParameters: <String, dynamic>{
          'initial_date': initialDate.toIso8601String(),
          'final_date': finalDate.toIso8601String(),
        },
      );

      await _metricsMonitor.stopTrace(trace);

      if (result.data != null) {
        final expensesList = List<Map<String, dynamic>>.from(result.data!);
        return expensesList.map(ExpenseModel.fromMap).toList();
      }

      return <ExpenseModel>[];
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar despesa', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }
}
