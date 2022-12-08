import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';
import 'package:onde_gastei_app/app/modules/user/services/user_service.dart';

enum UserState { idle, loading, error, success }

enum UserDeleteAccountState { idle, loading, error, success }

class UserControllerImpl extends ChangeNotifier implements UserController {
  UserControllerImpl({
    required UserService service,
    required LocalStorage localStorage,
    required Log log,
  })  : _service = service,
        _localStorage = localStorage,
        _log = log;

  final UserService _service;
  final Log _log;
  final LocalStorage _localStorage;
  late UserModel user;

  UserState state = UserState.idle;
  UserDeleteAccountState stateDeleteAccount = UserDeleteAccountState.idle;

  @override
  Future<void> fetchUserData() async {
    try {
      state = UserState.loading;
      notifyListeners();

      user = await _service.fetchUserData();

      state = UserState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar dados do usuario', e, s);

      state = UserState.error;
      notifyListeners();

      throw Failure(message: 'Erro ao buscar dados do usuario');
    }
  }

  @override
  Future<void> updateUserName(int userId, String newUserName) async {
    try {
      state = UserState.loading;
      notifyListeners();

      await _service.updateUserName(userId, newUserName);
      await _service.removeLocalUserData();
      await fetchUserData();

      state = UserState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      _log.error('Erro ao atualizar dados do usuario', e, s);

      state = UserState.error;
      notifyListeners();

      throw Failure(message: 'Erro ao atualizar dados do usuario');
    }
  }

  @override
  Future<UserModel?> getLocalUser() async {
    try {
      final localUser =
          await _localStorage.read<String>(Constants.localUserKey);

      if (localUser != null && localUser.isNotEmpty) {
        return user =
            UserModel.fromMap(jsonDecode(localUser) as Map<String, dynamic>);
      }

      return null;
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar dados do usuario local', e, s);
      throw Failure(message: 'Erro ao buscar dados do usuario local');
    }
  }

  @override
  Future<void> deleteAccountUser(int userId) async {
    try {
      stateDeleteAccount = UserDeleteAccountState.loading;
      notifyListeners();
      await _service.deleteAccountUser(userId);
      stateDeleteAccount = UserDeleteAccountState.success;
      notifyListeners();
    } on Exception catch (e, s) {
      stateDeleteAccount = UserDeleteAccountState.error;
      notifyListeners();
      _log.error('Erro ao conta de usuario', e, s);
      throw Failure(message: 'Erro ao conta de usuario');
    }
  }

  @override
  void logout() => _localStorage.logout();
}
