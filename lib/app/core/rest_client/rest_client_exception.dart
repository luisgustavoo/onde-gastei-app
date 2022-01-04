import 'package:onde_gastei_app/app/core/rest_client/rest_client_response.dart';

class RestClientException implements Exception {
  RestClientException({
    required this.error,
    this.message,
    this.statusCode,
    this.response,
  });

  final String? message;
  final int? statusCode;
  final dynamic error;
  final RestClientResponse? response;

  @override
  String toString() {
    return 'RestClientException(message: $message, statusCode: $statusCode, error: $error, response: $response)';
  }
}
