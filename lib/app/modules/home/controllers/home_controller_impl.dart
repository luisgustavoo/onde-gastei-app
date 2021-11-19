import 'package:flutter/cupertino.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';

class HomeControllerImpl extends ChangeNotifier implements HomeController {
  HomeControllerImpl({required HomeService service}) : _service = service;
  final HomeService _service;
  late UserModel userModel;

  @override
  Future<void> fetchUserData() async {
    userModel = await _service.fetchUserData();
    notifyListeners();
  }
}
