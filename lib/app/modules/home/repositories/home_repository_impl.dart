import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required RestClient restClient, required Log log})
      : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  @override
  Future<UserModel> fetchUserData() async {
    try {
      final result = await _restClient.auth().get<Map<String, dynamic>>(
            '/users/',
          );

      if (result.data == null || result.data!.isEmpty) {
        throw UserNotFoundException();
      }

      return UserModel.fromMap(result.data!);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar dados do usuario', e, s);

      throw Failure(message: 'Erro ao buscar dados do usuario');
    }
  }
}
