import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_security_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository.dart';
import 'package:onde_gastei_app/app/modules/user/services/user_service.dart';

class UserServiceImpl implements UserService {
  UserServiceImpl({
    required UserRepository repository,
    required LocalSecurityStorage localSecurityStorage,
    required Log log,
  })  : _repository = repository,
        _log = log,
        _localSecurityStorage = localSecurityStorage;

  final UserRepository _repository;
  final Log _log;
  final LocalSecurityStorage _localSecurityStorage;

  @override
  Future<UserModel> fetchUserData() => _repository.fetchUserData();

  @override
  Future<void> updateUserName(int userId, String newUserName) =>
      _repository.updateUserName(userId, newUserName);

  @override
  Future<void> removeLocalUserData() => _repository.removeLocalUserData();

  @override
  Future<void> deleteAccountUser(int userId) async {
    try {
      final credential =
          await _localSecurityStorage.read(Constants.firebaseCredentialKey);

      if (credential != null) {
        final credentialMap = jsonDecode(credential) as Map<String, dynamic>;
        final email = credentialMap['email'].toString();
        final password = credentialMap['password'].toString();
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        await FirebaseAuth.instance.currentUser!.delete();
        await _repository.deleteAccountUser(userId);
      }
    } on Exception catch (e, s) {
      _log.error('Erro ao deletar conta de usuario', e, s);
      throw Failure();
    }
  }
}
