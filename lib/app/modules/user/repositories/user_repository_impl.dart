import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required RestClient restClient,
    required LocalStorage localStorage,
    required Log log,
    required MetricsMonitor metricsMonitor,
  })  : _restClient = restClient,
        _localStorage = localStorage,
        _log = log,
        _metricsMonitor = metricsMonitor;

  final RestClient _restClient;
  final Log _log;
  final LocalStorage _localStorage;
  final MetricsMonitor _metricsMonitor;

  @override
  Future<UserModel> fetchUserData() async {
    final trace = _metricsMonitor.addTrace('fetch-user-data');
    try {
      await _metricsMonitor.startTrace(trace);

      final result = await _restClient.auth().get<Map<String, dynamic>>(
            '/users/',
          );

      await _metricsMonitor.stopTrace(trace);

      if (result.data == null || result.data!.isEmpty) {
        throw UserNotFoundException();
      }

      final user = UserModel(
        userId: int.parse(result.data!['id_usuario'].toString()),
        name: result.data!['nome'].toString(),
        email: FirebaseAuth.instance.currentUser?.email ?? '',
        firebaseUserId: result.data!['id_usuario_firebase'].toString(),
      );

      await _saveLocalUserData(user);
      return user;
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar dados do usuario', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure(message: 'Erro ao buscar dados do usuario');
    }
  }

  @override
  Future<void> updateUserName(int userId, String newUserName) async {
    final trace = _metricsMonitor.addTrace('update-user-name');
    try {
      await _metricsMonitor.startTrace(trace);
      await _restClient.auth().put(
        '/users/$userId/update',
        data: <String, dynamic>{
          'nome': newUserName,
        },
      );
      await _metricsMonitor.stopTrace(trace);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao atualizar nome de usuario', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<void> removeLocalUserData() =>
      _localStorage.remove(Constants.localUserKey);

  Future<void> _saveLocalUserData(UserModel user) => _localStorage.write(
        Constants.localUserKey,
        jsonEncode(
          user.toMap(),
        ),
      );

  @override
  Future<void> deleteAccountUser(int userId) async {
    try {
      await _restClient.auth().delete<void>(
            '/users/$userId',
          );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao deletar conta de usuario', e, s);
      throw Failure();
    }
  }
}
