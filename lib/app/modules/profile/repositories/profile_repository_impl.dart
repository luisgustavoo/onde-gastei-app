import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/modules/profile/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required RestClient restClient, required Log log,})
      : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

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
      _log.error('Erro ao atualizar nome de usuário', e, s);
      throw Failure();
    }
  }
}
