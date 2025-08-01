import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_service.dart';

enum AuthState { idle, loading, error, success }

class AuthControllerImpl extends ChangeNotifier implements AuthController {
  AuthControllerImpl({
    required AuthService service,
    required Log log,
    required LocalStorage localStorage,
  }) : _service = service,
       _log = log,
       _localStorage = localStorage;

  final AuthService _service;
  final Log _log;
  final LocalStorage _localStorage;
  AuthState state = AuthState.idle;

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      state = AuthState.loading;
      notifyListeners();

      await _service.register(name, email, password);

      state = AuthState.success;
      notifyListeners();
    } on UserExistsException catch (e, s) {
      _log.error('Email já cadastrado, por favor escolha outro e-mail', e, s);

      state = AuthState.error;
      notifyListeners();

      throw UserExistsException();
    } on Exception catch (e, s) {
      _log.error('Erro ao registrar usuário', e, s);

      state = AuthState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      state = AuthState.loading;
      notifyListeners();

      await _service.login(email, password);

      state = AuthState.success;
      notifyListeners();
    } on UserNotFoundException catch (e, s) {
      _log.error('Login e senha inválidos', e, s);

      state = AuthState.error;
      notifyListeners();

      throw UserNotFoundException();
    } on UnverifiedEmailException catch (e, s) {
      _log.error('E-mail não verificado!', e, s);

      state = AuthState.error;
      notifyListeners();

      throw UnverifiedEmailException();
    } on Exception catch (e, s) {
      _log.error('Erro ao realizar login tente novamente mais tarde!!!', e, s);

      state = AuthState.error;
      notifyListeners();

      throw Failure();
    }
  }

  @override
  Future<void> logout() async {
    await _localStorage.clear();
  }

  @override
  Future<void> resetPassword(String email) => _service.resetPassword(email);
}
