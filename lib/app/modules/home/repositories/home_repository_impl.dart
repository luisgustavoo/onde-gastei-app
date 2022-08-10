import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
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
  Future<List<TotalExpensesCategoriesViewModel>> findTotalExpensesByCategories(
    int userId,
    DateTime initialDate,
    DateTime finalDate,
  ) async {
    final trace = _metricsMonitor.addTrace('find-total-expenses-by-categories');
    try {
      await _metricsMonitor.startTrace(trace);

      final result = await _restClient.auth().get<List<dynamic>>(
        '/users/$userId/total-expenses/categories',
        queryParameters: <String, dynamic>{
          'initial_date': initialDate,
          'final_date': finalDate
        },
      );

      await _metricsMonitor.stopTrace(trace);

      if (result.data != null) {
        final totalExpensesCategoriesList =
            List<Map<String, dynamic>>.from(result.data!);

        return totalExpensesCategoriesList
            .map(TotalExpensesCategoriesViewModel.fromMap)
            .toList();
      }

      return <TotalExpensesCategoriesViewModel>[];
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar total por categoria', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure(message: 'Erro ao buscar total por categoria');
    }
  }

  @override
  Future<List<PercentageCategoriesViewModel>> findPercentageByCategories(
    int userId,
    DateTime initialDate,
    DateTime finalDate,
  ) async {
    final trace = _metricsMonitor.addTrace('find-percentage-by-categories');

    try {
      await _metricsMonitor.startTrace(trace);

      final result = await _restClient.auth().get<List<dynamic>>(
        '/users/$userId/percentage/categories',
        queryParameters: <String, dynamic>{
          'initial_date': initialDate,
          'final_date': finalDate
        },
      );

      await _metricsMonitor.stopTrace(trace);

      if (result.data != null) {
        final percentageCategoriesList =
            List<Map<String, dynamic>>.from(result.data!);

        return percentageCategoriesList
            .map(PercentageCategoriesViewModel.fromMap)
            .toList();
      }

      return <PercentageCategoriesViewModel>[];
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar percentual por categoria', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure(message: 'Erro ao buscar percentual por categoria');
    }
  }
}
