
import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/navigator/onde_gastei_navigator.dart';
import 'package:onde_gastei_app/app/core/pages/app_page.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/loader.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/messages.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_service.dart';
import 'package:onde_gastei_app/app/modules/splash/splash_page.dart';

class AuthControllerImpl extends ChangeNotifier implements AuthController {
  AuthControllerImpl({
    required AuthService service,
    required Log log,
    required LocalStorage localStorage,
  })  : _service = service,
        _log = log,
        _localStorage = localStorage;

  final AuthService _service;
  final Log _log;
  final LocalStorage _localStorage;

  @override
  Future<bool> isLogged() async {
    final localUser = await _localStorage.read<String>('user');
    if (localUser != null && localUser.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await _service.register(name, email, password);
    } on UserExistsException catch (e, s) {
      _log.error('Email já cadastrado, por favor escolha outro e-mail', e, s);
    } on Exception catch (e, s) {
      _log.error('Erro ao registrar usuário', e, s);
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      await _service.login(email, password);
      //await OndeGasteiNavigator.to!.pushReplacementNamed(AppPage.router);
    } on UserNotFoundException catch (e, s) {
      _log.error('Login e senha inválidos', e, s);
    } on UnverifiedEmailException catch (e, s) {
      _log.error('E-mail não verificado!', e, s);
    } on Exception catch (e, s) {
      _log.error('Erro ao realizar login tente novamente mais tarde!!!', e, s);
    }
  }

  @override
  Future<void> logout() async {
    await _localStorage.clear();
    await OndeGasteiNavigator.to!.pushReplacementNamed(SplashPage.router);
  }
}
