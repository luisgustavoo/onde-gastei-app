import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_security_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(
      {required RestClient restClient,
      required LocalStorage localStorage,
      required LocalSecurityStorage localSecurityStorage,
      required Log log})
      : _localSecurityStorage = localSecurityStorage,
        _localStorage = localStorage,
        _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;
  final LocalStorage _localStorage;
  final LocalSecurityStorage _localSecurityStorage;

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

  @override
  Future<void> refreshToken() async {
    try {
      final refreshToken =
          await _localSecurityStorage.read(Constants.refreshToken);

      final refreshTokenResult =
          await _restClient.auth().put<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (refreshTokenResult.data != null) {
        await _localSecurityStorage.write(
          Constants.refreshToken,
          refreshTokenResult.data!['refresh_token'].toString(),
        );
        await _localStorage.write(
          Constants.accessToken,
          refreshTokenResult.data!['access_token'].toString(),
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
