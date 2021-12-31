import 'package:flutter/cupertino.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/loader.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

class HomeControllerImpl extends ChangeNotifier implements HomeController {
  HomeControllerImpl({required HomeService service}) : _service = service;
  final HomeService _service;
  late UserModel _userModel;
  var _totalExpensesCategoriesList = <TotalExpensesCategoriesViewModel>[];
  var _percentageCategoriesList = <PercentageCategoriesViewModel>[];

  @override
  Future<void> fetchHomeData({
    required int userId,
    required DateTime initialDate,
    required DateTime finalDate,
  }) async {
    try {
      Loader.show();

      _totalExpensesCategoriesList = await _service
          .findTotalExpensesByCategories(userId, initialDate, finalDate);
      _percentageCategoriesList = await _service.findPercentageByCategories(
          userId, initialDate, finalDate);
      Loader.hide();
      notifyListeners();
    } on Exception {
      Loader.hide();
      throw Failure(message: 'Erro ao buscar dados da home page');
    }
  }

  @override
  Future<UserModel> fetchUserData() async =>
      _userModel = await _service.fetchUserData();
}
