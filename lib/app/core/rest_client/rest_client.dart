import 'package:onde_gastei_app/app/core/rest_client/rest_client_response.dart';

abstract class RestClient {
  RestClient auth();
  RestClient unAuth();

  Future<RestClientResponse<T>> post<T>(
    String path, {
    T data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> put<T>(
    String path, {
    T data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> delete<T>(
    String path, {
    T data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> patch<T>(
    String path, {
    T data,
    Map<String, dynamic> queryParameters,
    Map<String, dynamic> headers,
  });

  Future<RestClientResponse<T>> request<T>(
    String path, {
    required String method,
    T data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}
