import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl({required RestClient restClient, required Log log})
      : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  @override
  Future<void> register(CategoryModel categoryModel) async {
    try {
      await _restClient.auth().post<Map<String, dynamic>>('/category/register',
          data: <String, dynamic>{
            'descricao': categoryModel.description,
            'codigo_icone': categoryModel.iconCode,
            'codigo_cor': categoryModel.colorCode,
            'id_usuario': categoryModel.userId
          });
    } on RestClientException catch (e, s) {
      _log.error('Erro ao registrar categoria', e, s);
      throw Failure();
    }
  }

  @override
  Future<void> updateCategory(
      int categoryId, CategoryInputModel categoryInputModel) async {
    try {
      await _restClient.auth().put<Map<String, dynamic>>(
          '/category/$categoryId/update',
          data: <String, dynamic>{
            'descricao': categoryInputModel.description,
            'codigo_icone': categoryInputModel.iconCode,
            'codigo_cor': categoryInputModel.colorCode
          });
    } on RestClientException catch (e, s) {
      _log.error('Erro ao atualizar categoria', e, s);
      throw Failure();
    }
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    try {
      await _restClient
          .auth()
          .delete<Map<String, dynamic>>('/category/$categoryId/delete');
    } on RestClientException catch (e, s) {
      _log.error('Erro ao excluir categoria', e, s);
      throw Failure();
    }
  }

  @override
  Future<List<CategoryModel>> findCategories(int userId) async {
    try {
      final result = await _restClient
          .auth()
          .get<List<dynamic>>('/users/$userId/categories');

      if (result.data != null) {
        final categoriesList = List<Map<String, dynamic>>.from(result.data!);
        return categoriesList.map((c) => CategoryModel.fromMap(c)).toList();
      }

      return <CategoryModel>[];
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar categories do usuário $userId', e, s);
      throw Failure();
    }
  }
}
