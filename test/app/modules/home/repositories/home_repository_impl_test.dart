import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/logs/log_impl.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository_impl.dart';

import '../../../../core/fixture/fiture_reader.dart';
import '../../../../core/local_storage/mock_local_storage.dart';
import '../../../../core/log/mock_log.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient restClient;
  late Log log;
  late LocalStorage localStorage;
  late HomeRepositoryImpl repository;

  setUp(() {
    log = MockLog();
    restClient = MockRestClient();
    localStorage = MockLocalStorage();
    repository = HomeRepositoryImpl(
        restClient: restClient, localStorage: localStorage, log: log);
  });

  group('Group test fetchUserData', () {
    test('Should fetch user data with success', () async {
      // Arrange
      final jsonData = FixtureReader.getJsonData(
          'app/modules/home/repositories/fixture/get_data_by_token_success.json');
      final responseData = jsonDecode(jsonData) as Map<String, dynamic>;

      final userExpected = UserModel(
        userId: int.parse(responseData['id_usuario'].toString()),
        name: responseData['nome'].toString(),
        email: responseData['email'].toString(),
      );

      final mockResponse =
          MockRestClientResponse(statusCode: 200, data: responseData);

      when(() => restClient.get<Map<String, dynamic>>(any()))
          .thenAnswer((_) async => mockResponse);
      when(() => localStorage.write<String>(any(), any()))
          .thenAnswer((_) async => _);
      //Act
      final user = await repository.fetchUserData();

      //Assert
      expect(user, userExpected);
    });

    test('Should throws UserNotFoundException', () async {
      // Arrange
      final mockResponse =
          MockRestClientResponse(statusCode: 200, data: <String, dynamic>{});

      when(() => restClient.get<Map<String, dynamic>>(any()))
          .thenAnswer((_) async => mockResponse);
      when(() => localStorage.write<String>(any(), any()))
          .thenAnswer((_) async => _);
      //Act
      final call = repository.fetchUserData;

      //Assert
      expect(call, throwsA(isA<UserNotFoundException>()));
    });

    test('Should throws Failure', () async {
      // Arrange
      when(() => restClient.get<Map<String, dynamic>>(any()))
          .thenThrow(RestClientException(error: 'Error'));
      when(() => localStorage.write<String>(any(), any()))
          .thenAnswer((_) async => _);
      //Act
      final call = repository.fetchUserData;

      //Assert
      expect(call, throwsA(isA<Failure>()));
    });
  });
}
