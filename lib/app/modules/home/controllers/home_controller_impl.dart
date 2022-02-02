import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

enum homeState { idle, loading, error, success }

class HomeControllerImpl extends ChangeNotifier implements HomeController {
  HomeControllerImpl({
    required HomeService service,
    required LocalStorage localStorage,
    required Log log,
  })  : _service = service,
        _localStorage = localStorage,
        _log = log;

  final HomeService _service;
  final LocalStorage _localStorage;
  final Log _log;

  UserModel? userModel;
  List<TotalExpensesCategoriesViewModel> totalExpensesCategoriesList =
      <TotalExpensesCategoriesViewModel>[];
  List<PercentageCategoriesViewModel> percentageCategoriesList =
      <PercentageCategoriesViewModel>[];
  homeState state = homeState.idle;

  @override
  Future<void> fetchHomeData({
    required int userId,
    required DateTime initialDate,
    required DateTime finalDate,
  }) async {
    try {
      state = homeState.loading;
      notifyListeners();

      totalExpensesCategoriesList = await _service
          .findTotalExpensesByCategories(userId, initialDate, finalDate);
      percentageCategoriesList = await _service.findPercentageByCategories(
        userId,
        initialDate,
        finalDate,
      );

      state = homeState.success;
      notifyListeners();
    } on Exception {
      state = homeState.error;
      notifyListeners();

      throw Failure(message: 'Erro ao buscar dados da home page');
    }
  }

  @override
  Future<UserModel?> fetchUserData() async {
    try {
      state = homeState.loading;
      notifyListeners();

      final localUser = await _localStorage.read<String>('user');

      if (localUser != null && localUser.isNotEmpty) {
        final userMap = jsonDecode(localUser) as Map<String, dynamic>;
        userModel = UserModel.fromMap(userMap);
      } else {
        userModel = await _service.fetchUserData();
      }

      state = homeState.success;
      notifyListeners();

      return userModel;
    } on Exception {
      state = homeState.error;
      notifyListeners();

      throw Failure(message: 'Erro ao buscar dados do usuário');
    }
  }
}
