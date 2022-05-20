import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_response.dart';

class MockRestClientException extends Mock implements RestClientException {
  MockRestClientException({
    this.message,
    this.statusCode,
    this.response,
  });

  @override
  final String? message;
  @override
  final int? statusCode;
  @override
  final RestClientResponse? response;
}
