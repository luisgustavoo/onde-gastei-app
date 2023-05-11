import 'package:dio/dio.dart';
import 'package:onde_gastei_app/app/core/helpers/environments.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_security_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/interceptors/auth_interceptor.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_response.dart';

class DioRestClient implements RestClient {
  DioRestClient({
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
    required Log log,
    BaseOptions? options,
  }) {
    _dio = Dio(options ?? _options)
      ..interceptors.addAll([
        //LogInterceptor(),
        AuthInterceptor(
          restClient: this,
          localStorage: localStorage,
          localSecurityStorage: localSecurityStorage,
          log: log,
        ),
      ]);
  }

  late Dio _dio;

  final _options = BaseOptions(
    baseUrl: Environments.param('base_url') ?? '',
    connectTimeout: Duration(
      milliseconds: int.parse(
        Environments.param('rest_connect_timeout') ?? '0',
      ),
    ),
    receiveTimeout: Duration(
      milliseconds: int.parse(
        Environments.param('rest_receive_timeout') ?? '0',
      ),
    ),
  );

  @override
  RestClient auth() {
    _options.extra['auth_required'] = true;
    return this;
  }

  @override
  RestClient unAuth() {
    _options.extra['auth_required'] = false;
    return this;
  }

  @override
  Future<RestClientResponse<T>> post<T>(
    String path, {
    T? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioError catch (e) {
      throw RestClientException(
        error: e.error,
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioError catch (e) {
      throw RestClientException(
        error: e.error,
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(
    String path, {
    T? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioError catch (e) {
      throw RestClientException(
        error: e.error,
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> delete<T>(
    String path, {
    T? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioError catch (e) {
      throw RestClientException(
        error: e.error,
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(
    String path, {
    T? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioError catch (e) {
      throw RestClientException(
        error: e.error,
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(
    String path, {
    required String method,
    T? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          method: method,
        ),
      );

      return RestClientResponse(
        data: response.data,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      );
    } on DioError catch (e) {
      throw RestClientException(
        error: e.error,
        message: e.response?.statusMessage,
        statusCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  RestClientResponse _dioErrorConvert(Response? response) {
    return RestClientResponse<dynamic>(
      data: response?.data,
      statusCode: response?.statusCode,
      statusMessage: response?.statusMessage,
    );
  }
}
