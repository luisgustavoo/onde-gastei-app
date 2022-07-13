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
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    //super.onRequest(options, handler);
    final authRequired =
        options.extra[Constants.restClientAuthRequiredKey] as bool? ?? false;

    if (authRequired == true) {
      final accessToken =
          await _localStorage.read<String>(Constants.accessTokenKey);
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
    } else {
      options.headers.remove('Authorization');
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

    final statusCode = err.response?.statusCode;

    if (err.requestOptions.extra[Constants.restClientAuthRequiredKey] == true) {
      if (statusCode == 403 || statusCode == 401) {
        await _refreshToken();
        _log
          ..append('########### Refresh Token Atualizado ###########')
          ..closeAppend();
        return _retryRequest(err, handler);
      }
    }

    _log
      ..append('########### Error LOG ###########')
      ..append('Error: ${err.response}')
      ..append('########### Error LOG ###########')
      ..closeAppend();

    handler.next(err);
  }

  Future<void> _refreshToken() async {
    try {
      final refreshToken =
          await _localSecurityStorage.read(Constants.refreshTokenKey);

      final refreshTokenResult =
          await _restClient.auth().put<Map<String, dynamic>>(
        '/auth/refresh',
        data: <String, dynamic>{'refresh_token': refreshToken},
      );

      if (refreshTokenResult.data != null) {
        await _localSecurityStorage.write(
          Constants.refreshTokenKey,
          refreshTokenResult.data!['refresh_token'].toString(),
        );
        await _localStorage.write(
          Constants.accessTokenKey,
          refreshTokenResult.data!['access_token'].toString(),
        );
      }
    } on Exception catch (e, s) {
      _log.error('Erro ao atualizar refresh token', e, s);
      // throw UpdateRefreshTokenException();
    }
  }

  Future<void> _retryRequest(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    _log
      ..append('########### Retry Request ###########')
      ..closeAppend();
    try {
      final requestOptions = err.requestOptions;

      final response = await _restClient.auth().request<dynamic>(
            requestOptions.path,
            method: requestOptions.method,
            data: requestOptions.data,
            headers: requestOptions.headers,
            queryParameters: requestOptions.queryParameters,
          );

      handler.resolve(
        Response<dynamic>(
          requestOptions: requestOptions,
          data: response.data,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
        ),
      );
    } on DioError catch (e, s) {
      _log.error('Erro ao refazer request', e, s);
      handler.reject(e);
    }
  }
}
