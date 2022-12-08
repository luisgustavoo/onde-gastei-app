import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_security_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/auth/repositories/auth_repository.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_service.dart';
import 'package:onde_gastei_app/flavors.dart';

class AuthServicesImpl implements AuthService {
  AuthServicesImpl({
    required AuthRepository repository,
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
    required Log log,
    required FirebaseAuth firebaseAuth,
  })  : _repository = repository,
        _localStorage = localStorage,
        _localSecurityStorage = localSecurityStorage,
        _log = log,
        _firebaseAuth = firebaseAuth;

  final AuthRepository _repository;
  final LocalStorage _localStorage;
  final LocalSecurityStorage _localSecurityStorage;
  final Log _log;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      final firebaseAuth = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseAuth.user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Usuario não encontrado',
        );
      }

      await _repository.register(name, firebaseAuth.user!.uid);

      if (firebaseAuth.user != null && F.appFlavor != Flavor.dev) {
        await firebaseAuth.user!.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao registrar usuário no FirebaseAuth', e, s);
      throw Failure(message: 'Erro ao registrar usuário no FirebaseAuth');
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      final firebaseAuth = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseAuth.user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Usuario não encontrado',
        );
      }

      if (F.appFlavor != Flavor.dev) {
        if (!firebaseAuth.user!.emailVerified) {
          throw UnverifiedEmailException();
        }
      }

      final accessToken = await _repository.login(firebaseAuth.user!.uid);

      await _saveAccessToken(accessToken);
      await _saveFirebaseCredential(email, password);

      await _confirmLogin();
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao realizar login no FirebaseAuth', e, s);
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        throw UserNotFoundException();
      }
      throw Failure(message: 'Erro ao realizar login no FirebaseAuth');
    } on Exception catch (e) {
      if ((e is UnverifiedEmailException) || (e is UserNotFoundException)) {
        rethrow;
      }
      throw Failure(message: 'Erro ao realizar login');
    }
  }

  Future<void> _saveAccessToken(String accessToken) async =>
      _localStorage.write(Constants.accessTokenKey, accessToken);

  Future<void> _confirmLogin() async {
    final confirmModel = await _repository.confirmLogin();
    await _saveAccessToken(confirmModel.accessToken);
    await _localSecurityStorage.write(
      Constants.refreshTokenKey,
      confirmModel.refreshToken,
    );
  }

  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> _saveFirebaseCredential(String email, String password) async {
    await _localSecurityStorage.write(
      Constants.firebaseCredentialKey,
      jsonEncode({'email': email, 'password': password}),
    );
  }
}
