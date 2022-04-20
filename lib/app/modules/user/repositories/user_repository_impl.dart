import 'dart:convert';

import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required RestClient restClient,
    required LocalStorage localStorage,
    required Log log,
  })  : _restClient = restClient,
        _localStorage = localStorage,
        _log = log;

  final RestClient _restClient;
  final Log _log;
  final LocalStorage _localStorage;

  @override
  Future<UserModel> fetchUserData() async {
    try {
      final result = await _restClient.auth().get<Map<String, dynamic>>(
            '/users/',
          );

      if (result.data == null || result.data!.isEmpty) {
        throw UserNotFoundException();
      }
      final user = UserModel.fromMap(result.data!);
      await _saveLocalUserData(user);
      return user;
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar dados do usuario', e, s);

      throw Failure(message: 'Erro ao buscar dados do usuario');
    }
  }

  @override
  Future<void> updateUserName(int userId, String newUserName) async {
    try {
      await _restClient.auth().put(
        'users/$userId/update',
        data: <String, dynamic>{
          'nome': newUserName,
        },
      );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao atualizar nome de usuario', e, s);
      throw Failure();
    }
  }

  Future<void> _saveLocalUserData(UserModel user) => _localStorage.write(
        'user',
        jsonEncode(
          user.toMap(),
        ),
      );
}
