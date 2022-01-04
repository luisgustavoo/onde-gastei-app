import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/auth/repositories/auth_repository_impl.dart';

import '../../../core/log/mock_log.dart';
import '../../../core/rest_client/mock_rest_client.dart';
import '../../../core/rest_client/mock_rest_client_exception.dart';
import '../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late AuthRepositoryImpl authRepository;
  late Log log;
  late MockRestClient restClient;

  setUp(() {
    log = MockLog();
    restClient = MockRestClient();
    authRepository = AuthRepositoryImpl(restClient: restClient, log: log);

  });

  group('Group test register ', () {
    test('Should register user with success', () async {
      // Arrange
      const name = 'Blá Blá';
      const email = 'blabla@teste.com';
      const password = '123456';
      const requestData = <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
      };

      final mockResponse =
          MockRestClientResponse<Map<String, dynamic>>(statusCode: 200);

      when(() =>
              restClient.post<Map<String, dynamic>>(any(), data: requestData))
          .thenAnswer((_) async => mockResponse);

      //Act
      await authRepository.register(name, email, password);

      //Assert
      verify(() =>
              restClient.post<Map<String, dynamic>>(any(), data: requestData))
          .called(1);
    });

    test('Should throw UserExistsException', () async {
      // Arrange
      const name = 'Blá Blá';
      const email = 'blabla@teste.com';
      const password = '123456';
      const requestData = <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
      };
      const responseData = <String, dynamic>{
        'message': 'Usuário já cadastrado'
      };
      final mockResponse = MockRestClientResponse<Map<String, dynamic>>(
          data: responseData, statusCode: 400);
      final mockException =
          MockRestClientException(statusCode: 400, response: mockResponse);

      when(() =>
              restClient.post<Map<String, dynamic>>(any(), data: requestData))
          .thenThrow(mockException);

      //Act
      final call = authRepository.register;

      //Assert
      expect(call(name, email, password), throwsA(isA<UserExistsException>()));
    });

    test('Should throw Failure', () async {
      // Arrange
      const name = 'Blá Blá';
      const email = 'blabla@teste.com';
      const password = '123456';
      const requestData = <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
      };
      const responseData = <String, dynamic>{
        'message': 'Erro ao registrar usuário'
      };
      final mockResponse = MockRestClientResponse<Map<String, dynamic>>(
          data: responseData, statusCode: 500);
      final mockException =
          MockRestClientException(statusCode: 500, response: mockResponse);

      when(() =>
              restClient.post<Map<String, dynamic>>(any(), data: requestData))
          .thenThrow(mockException);

      //Act
      final call = authRepository.register;

      //Assert
      expect(call(name, email, password), throwsA(isA<Failure>()));
    });
  });
}
