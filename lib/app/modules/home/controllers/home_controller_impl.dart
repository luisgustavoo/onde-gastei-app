import 'package:flutter/cupertino.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/loader.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';

class HomeControllerImpl extends ChangeNotifier implements HomeController {
  HomeControllerImpl({required HomeService service}) : _service = service;
  final HomeService _service;
  late UserModel userModel;

  @override
  Future<void> fetchUserData() async {
    try {
      Loader.show();
      userModel = await _service.fetchUserData();
      Loader.hide();
      notifyListeners();
    } on Exception catch (e) {
      Loader.hide();
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      Loader.show();
      await _service.refreshToken();
      Loader.hide();
      notifyListeners();
    } on Exception catch (e) {
      Loader.hide();
    }
  }
}
