import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/loader.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/messages.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_service.dart';

class AuthControllerImpl extends ChangeNotifier implements AuthController {
  AuthControllerImpl({
    required AuthService service,
    required Log log,
    required SharedPreferencesLocalStorageImpl localStorage,
  })  : _service = service,
        _log = log,
        _localStorage = localStorage;

  final AuthService _service;
  final Log _log;
  final SharedPreferencesLocalStorageImpl _localStorage;

  @override
  Future<bool> isLogged() async {
    final user = await _localStorage.read<String>('user');
    if (user != null && user.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      Loader.show();
      await _service.register(name, email, password);
      Loader.hide();
      Messages.info(
          'Cadastro realizado com sucesso! Verifique o e-mail cadastrado para concluir o processo');
    } on UserExistsException {
      Loader.hide();
      Messages.alert('E-mail já cadastrado, por favor escolha outro e-mail');
    } on Exception catch (e, s) {
      Loader.hide();
      _log.error('Erro ao registrar usuário', e, s);
      Messages.alert('Erro ao registrar usuário, tente novamente mais tarde');
    }
  }

  @override
  Future<bool> login(String email, String password) async {
    try {
      Loader.show();
      await _service.login(email, password);
      Loader.hide();
      return true;
    } on UserNotFoundException catch (e, s) {
      Loader.hide();
      _log.error('Login e senha inválidos', e, s);
      Messages.alert('Login e senha inválidos');
      return false;
    } on UnverifiedEmailException catch (e, s) {
      Loader.hide();
      Messages.alert('E-mail não verificado!');
      _log.error('E-mail não verificado!', e, s);
      return false;
    } on Exception catch (e, s) {
      Loader.hide();
      Messages.alert('Erro ao realizar login');
      _log.error('Erro ao realizar login tente novamente mais tarde!!!', e, s);
      return false;
    }
  }
}
