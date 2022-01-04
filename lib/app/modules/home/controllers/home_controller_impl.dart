import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/loader.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

class HomeControllerImpl extends ChangeNotifier implements HomeController {
  HomeControllerImpl(
      {required HomeService service, required LocalStorage localStorage})
      : _service = service,
        _localStorage = localStorage;

  bool isLoading = true;
  final HomeService _service;
  final LocalStorage _localStorage;
  late UserModel userModel;
  List<TotalExpensesCategoriesViewModel> totalExpensesCategoriesList =
      <TotalExpensesCategoriesViewModel>[];
  List<PercentageCategoriesViewModel> percentageCategoriesList =
      <PercentageCategoriesViewModel>[];

  @override
  Future<void> fetchHomeData({
    required int userId,
    required DateTime initialDate,
    required DateTime finalDate,
  }) async {
    try {
      //Loader.show();
      isLoading = true;
      notifyListeners();

      totalExpensesCategoriesList = await _service
          .findTotalExpensesByCategories(userId, initialDate, finalDate);
      percentageCategoriesList = await _service.findPercentageByCategories(
          userId, initialDate, finalDate);
      Loader.hide();
      isLoading = false;
      notifyListeners();
    } on Exception {
      isLoading = false;
      Loader.hide();
      notifyListeners();
      throw Failure(message: 'Erro ao buscar dados da home page');
    }
  }

  @override
  Future<UserModel> fetchUserData() async {
    try {
      isLoading = true;
      notifyListeners();
      final localUser = await _localStorage.read<String>('user');

      if (localUser != null && localUser.isNotEmpty) {
        final userMap = jsonDecode(localUser) as Map<String, dynamic>;
        userModel = UserModel.fromMap(userMap);
      } else {
        userModel = await _service.fetchUserData();
      }

      isLoading = false;
      notifyListeners();
      return userModel;
    } on Exception {
      isLoading = false;
      notifyListeners();
      Loader.hide();
      notifyListeners();
      throw Failure(message: 'Erro ao buscar dados do usuário');
    }
  }
}
