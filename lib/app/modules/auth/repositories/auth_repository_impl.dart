import 'package:firebase_performance/firebase_performance.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/modules/auth/repositories/auth_repository.dart';
import 'package:onde_gastei_app/app/modules/auth/view_models/confirm_login_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required RestClient restClient,
    required Log log,
    required MetricsMonitor metricsMonitor,
  })  : _restClient = restClient,
        _log = log,
        _metricsMonitor = metricsMonitor;

  final RestClient _restClient;
  final Log _log;
  final MetricsMonitor _metricsMonitor;

  @override
  Future<void> register(String name, String firebaseUserId) async {
    final trace = _metricsMonitor.addTrace('register-user');

    try {
      await _metricsMonitor.startTrace(trace);

      await _restClient.unAuth().post<Map<String, dynamic>>(
        '/auth/register',
        data: <String, dynamic>{
          'nome': name,
          'id_usuario_firebase': firebaseUserId,
        },
      );

      await _metricsMonitor.stopTrace(trace);
    } on RestClientException catch (e, s) {
      if (e.response != null) {
        final data = e.response!.data as Map<String, dynamic>?;
        if (data != null) {
          final dataMessage = data['message'].toString();

          if (e.statusCode == 400 &&
              dataMessage.toLowerCase().contains('usuário já cadastrado')) {
            _log.error('Usuário já cadastrado', e, s);
            await _metricsMonitor.stopTrace(trace);
            throw UserExistsException();
          }
        }
      }

      _log.error('Erro ao registrar usuário', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure();
    }
  }

  @override
  Future<String> login(String firebaseUserId) async {
    final trace = _metricsMonitor.addTrace('login');

    try {
      await _metricsMonitor.startTrace(trace);

      final result = await _restClient.unAuth().post<Map<String, dynamic>>(
        '/auth/',
        data: <String, dynamic>{
          'id_usuario_firebase': firebaseUserId,
        },
      );

      await _metricsMonitor.stopTrace(trace);

      if (result.data != null) {
        return result.data!['access_token'].toString();
      }

      return '';
    } on RestClientException catch (e, s) {
      _log.error('Erro ao realizar login', e, s);
      if (e.response != null) {
        if (e.response!.statusCode == 403) {
          _log.error('Usuário não encontrado', e, s);
          await _metricsMonitor.stopTrace(trace);
          throw UserNotFoundException();
        }
      }

      await _metricsMonitor.stopTrace(trace);

      throw Failure(message: 'Erro ao realizar login');
    }
  }

  @override
  Future<ConfirmLoginModel> confirmLogin() async {
    final trace = _metricsMonitor.addTrace('confirm-login');
    try {
      await _metricsMonitor.startTrace(trace);

      final result =
          await _restClient.auth().patch<Map<String, dynamic>>('/auth/confirm');

      await _metricsMonitor.stopTrace(trace);

      return ConfirmLoginModel.fromMap(result.data!);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao confirmar login', e, s);
      await _metricsMonitor.stopTrace(trace);
      throw Failure(message: 'Erro ao confirmar login');
    }
  }
}
