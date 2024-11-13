import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl({
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
  Future<void> register(CategoryModel categoryModel) async {
    final trace = _metricsMonitor.addTrace('register-category');
    try {
      await _metricsMonitor.startTrace(trace);

      await _restClient.auth().post<Map<String, dynamic>>(
        '/category/register',
        data: <String, dynamic>{
          'descricao': categoryModel.description,
          'codigo_icone': categoryModel.iconCode,
          'codigo_cor': categoryModel.colorCode,
          'id_usuario': categoryModel.userId,
        },
      );
      await _metricsMonitor.stopTrace(trace);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao registrar categoria', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<void> updateCategory(
    int categoryId,
    CategoryInputModel categoryInputModel,
  ) async {
    final trace = _metricsMonitor.addTrace('update-category');
    try {
      await _metricsMonitor.startTrace(trace);

      await _restClient.auth().put<Map<String, dynamic>>(
        '/category/$categoryId/update',
        data: <String, dynamic>{
          'descricao': categoryInputModel.description,
          'codigo_icone': categoryInputModel.iconCode,
          'codigo_cor': categoryInputModel.colorCode,
        },
      );
      await _metricsMonitor.stopTrace(trace);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao atualizar categoria', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    final trace = _metricsMonitor.addTrace('delete-category');
    try {
      await _metricsMonitor.startTrace(trace);

      await _restClient
          .auth()
          .delete<Map<String, dynamic>>('/category/$categoryId/delete');
      await _metricsMonitor.stopTrace(trace);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao excluir categoria', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<List<CategoryModel>> findCategories(int userId) async {
    final trace = _metricsMonitor.addTrace('find-categories');
    try {
      await _metricsMonitor.startTrace(trace);

      final result = await _restClient
          .auth()
          .get<List<dynamic>>('/users/$userId/categories');

      await _metricsMonitor.stopTrace(trace);

      if (result.data != null) {
        final categoriesList = List<Map<String, dynamic>>.from(result.data!);
        return categoriesList.map(CategoryModel.fromMap).toList();
      }

      return <CategoryModel>[];
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar categories do usuário $userId', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<int> expenseQuantityByCategoryId(int categoryId) async {
    final trace = _metricsMonitor.addTrace('expense-quantity-by-category-id');
    try {
      await _metricsMonitor.startTrace(trace);

      final result = await _restClient
          .auth()
          .get<Map<String, dynamic>>('/category/$categoryId/expenses-quantity');

      if (result.data != null) {
        await _metricsMonitor.stopTrace(trace);
        return int.parse(result.data!['quantidade'].toString());
      }

      throw Exception();
    } on Exception catch (e, s) {
      _log.error(
        'Erro buscar quantidade de despesas da categoria $categoryId',
        e,
        s,
      );

      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }
}
