import 'package:dio/dio.dart';
import 'package:onde_gastei_app/app/core/ui/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/ui/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/core/ui/rest_client/rest_client_response.dart';
import 'package:onde_gastei_app/helpers/environments.dart';

class DioRestClient implements RestClient {
  DioRestClient({BaseOptions? options}) {
    _dio = Dio(options ?? _options);
  }

  late Dio _dio;

  final _options = BaseOptions(
    baseUrl: Environments.param('base_url') ?? '',
    connectTimeout: int.parse(
      Environments.param('rest_connect_timeout') ?? '0',
    ),
    receiveTimeout: int.parse(
      Environments.param('rest_receive_timeout') ?? '0',
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
    dynamic data,
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
        stausCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
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
        stausCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
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
        stausCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> delete<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
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
        stausCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
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
        stausCode: e.response?.statusCode,
        response: _dioErrorConvert(e.response),
      );
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(String path,
      {required String method,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
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
        stausCode: e.response?.statusCode,
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