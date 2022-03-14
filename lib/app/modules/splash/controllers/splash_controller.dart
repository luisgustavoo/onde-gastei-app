import 'dart:convert';

import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';

class SplashController {
  SplashController({
    required LocalStorage localStorage,
    required Log log,
  })  : _localStorage = localStorage,
        _log = log;

  final LocalStorage _localStorage;
  final Log _log;

  Future<UserModel?> getUser() async {
    try {
      UserModel? user;

      final localUser = await _localStorage.read<String>('user');

      if (localUser != null && localUser.isNotEmpty) {
        user = UserModel.fromMap(jsonDecode(localUser) as Map<String, dynamic>);
      }

      return user;
    } on Exception catch (e, s) {
      _log.error('Erro ao buscar dados do usuario', e, s);
      throw Failure(message: 'Erro ao buscar dados do usuario');
    }
  }
}
