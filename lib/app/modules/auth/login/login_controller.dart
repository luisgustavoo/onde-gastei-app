import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';

class LoginController extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  Future<void> loadUser() async {
    _userModel = UserModel.empty();
    notifyListeners();
  }
}