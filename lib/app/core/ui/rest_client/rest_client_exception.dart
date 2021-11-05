import 'package:onde_gastei_app/app/core/ui/rest_client/rest_client_response.dart';

class RestClientException implements Exception {
  RestClientException({
    required this.error,
    this.message,
    this.stausCode,
    this.response,
  });

  final String? message;
  final int? stausCode;
  final dynamic error;
  final RestClientResponse? response;

  @override
  String toString() {
    return 'RestClientException(message: $message, stausCode: $stausCode, error: $error, response: $response)';
  }
}
