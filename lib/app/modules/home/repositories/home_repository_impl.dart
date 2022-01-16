import 'dart:convert';

import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(
      {required RestClient restClient,
      required Log log,
      required LocalStorage localStorage})
      : _restClient = restClient,
        _log = log,
        _localStorage = localStorage;

  final RestClient _restClient;
  final Log _log;
  final LocalStorage _localStorage;

  @override
  Future<UserModel> fetchUserData() async {
    try {
      final result = await _restClient.auth().get<Map<String, dynamic>>(
            '/users/',
          );

      if (result.data == null || result.data!.isEmpty) {
        throw UserNotFoundException();
      }

      await _saveLocalUserData(UserModel.fromMap(result.data!));

      return UserModel.fromMap(result.data!);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar dados do usuário', e, s);

      throw Failure(message: 'Erro ao buscar dados do usuário');
    }
  }

  Future<void> _saveLocalUserData(UserModel user) =>
      _localStorage.write('user', jsonEncode(user.toMap()));

  @override
  Future<List<TotalExpensesCategoriesViewModel>> findTotalExpensesByCategories(
      int userId, DateTime initialDate, DateTime finalDate) async {
    try {
      final result = await _restClient.auth().get<List<dynamic>>(
        '/users/$userId/total-expenses/categories',
        queryParameters: <String, dynamic>{
          'initial_date': initialDate,
          'final_date': finalDate
        },
      );

      if (result.data != null) {
        final totalExpensesCategoriesList =
            List<Map<String, dynamic>>.from(result.data!);

        return totalExpensesCategoriesList
            .map((e) => TotalExpensesCategoriesViewModel.fromMap(e))
            .toList();
      }

      return <TotalExpensesCategoriesViewModel>[];
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar total por categoria', e, s);

      throw Failure(message: 'Erro ao buscar total por categoria');
    }
  }

  @override
  Future<List<PercentageCategoriesViewModel>> findPercentageByCategories(
      int userId, DateTime initialDate, DateTime finalDate) async {
    try {
      final result = await _restClient.auth().get<List<dynamic>>(
        '/users/$userId/percentage/categories',
        queryParameters: <String, dynamic>{
          'initial_date': initialDate,
          'final_date': finalDate
        },
      );

      if (result.data != null) {
        final percentageCategoriesList =
            List<Map<String, dynamic>>.from(result.data!);

        return percentageCategoriesList
            .map((e) => PercentageCategoriesViewModel.fromMap(e))
            .toList();
      }

      return <PercentageCategoriesViewModel>[];
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar percentual por categoria', e, s);

      throw Failure(message: 'Erro ao buscar percentual por categoria');
    }
  }
}
