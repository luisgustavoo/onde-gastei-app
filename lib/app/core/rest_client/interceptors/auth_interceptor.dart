import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_security_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required RestClient restClient,
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
    required Log log,
  })  : _restClient = restClient,
        _localStorage = localStorage,
        _localSecurityStorage = localSecurityStorage,
        _log = log;

  final LocalStorage _localStorage;

  final LocalSecurityStorage _localSecurityStorage;

  final Log _log;

  final RestClient _restClient;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //super.onRequest(options, handler);

    if (options.extra['auth_required'] == true) {
      final accessToken =
          await _localStorage.read<String>(Constants.accessToken);
      if (accessToken == null) {
        //logout

        handler.reject(
          DioError(
            requestOptions: options,
            error: 'Expired Token',
            type: DioErrorType.cancel,
          ),
        );
      }

      options.headers['Authorization'] = accessToken;
    }

    if (!kReleaseMode) {
      _log
        ..append('########### Request LOG ###########')
        ..append('url: ${options.uri}')
        ..append('method: ${options.method}')
        ..append('data: ${options.data}')
        ..append('headers: ${options.headers}')
        ..append('########### Request LOG ###########')
        ..closeAppend();
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //super.onResponse(response, handler);

    if (!kReleaseMode) {
      _log
        ..append('########### Response LOG ###########')
        ..append('data: ${response.data}')
        ..append('########### Response LOG ###########')
        ..closeAppend();
    }

    handler.next(response);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    //super.onError(err, handler);

    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      await _refreshToken();

      await _restClient.auth().request<Map<String, dynamic>>(
            err.requestOptions.path,
            method: err.requestOptions.method,
          );
    }

    _log
      ..append('########### Error LOG ###########')
      ..append('Error: ${err.response}')
      ..append('########### Error LOG ###########')
      ..closeAppend();

    handler.next(err);
  }

  Future<void> _refreshToken() async {
    //final accessToken = _localStorage.read<String>(Constants.accessToken);
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
