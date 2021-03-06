import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository_impl.dart';

import '../../../../core/fixture/fixture_reader.dart';
import '../../../../core/log/mock_log.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

class MockLocalStorage extends Mock
    implements SharedPreferencesLocalStorageImpl {}

void main() {
  late RestClient mockRestClient;
  late Log mockLog;
  late UserRepository repository;
  late LocalStorage mockLocalStorage;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    mockRestClient = MockRestClient();
    mockLog = MockLog();
    repository = UserRepositoryImpl(
      restClient: mockRestClient,
      log: mockLog,
      localStorage: mockLocalStorage,
    );
  });

  group('Group test fetchUserData', () {
    test('Should fetch user data with success', () async {
      //Arrange
      const userModelExpected = UserModel(
        userId: 1,
        name: 'Luis Gustavo',
        firebaseUserId: 'l0D9NOWcVTPPwe5taAJgy9iO4nQ2',
      );
      final jsonData = FixtureReader.getJsonData(
        'app/modules/user/repositories/fixture/find_user_data_response.json',
      );

      final responseData = jsonDecode(jsonData) as Map<String, dynamic>;

      when(
        () => mockRestClient.get<Map<String, dynamic>>(
          any(),
        ),
      ).thenAnswer(
        (_) async =>
            MockRestClientResponse(statusCode: 200, data: responseData),
      );

      when(
        () => mockLocalStorage.write<String>(any(), any()),
      ).thenAnswer((_) async => _);

      //Act
      final userModel = await repository.fetchUserData();

      //Assert
      expect(userModel, userModelExpected);
      verify(
        () => mockRestClient.get<Map<String, dynamic>>(
          any(),
        ),
      ).called(1);
    });

    test('Should user not found', () async {
      //Arrange
      when(
        () => mockRestClient.get<Map<String, dynamic>>(
          any(),
        ),
      ).thenAnswer(
        (_) async => MockRestClientResponse(statusCode: 200),
      );

      //Act
      final call = repository.fetchUserData;

      //Assert
      expect(call(), throwsA(isA<UserNotFoundException>()));
      verify(
        () => mockRestClient.get<Map<String, dynamic>>(
          any(),
        ),
      ).called(1);
      verifyNever(() => mockLocalStorage.write<String>(any(), any()));
    });

    test('Should throws exception', () async {
      //Arrange
      when(
        () => mockRestClient.get<Map<String, dynamic>>(
          any(),
        ),
      ).thenThrow(RestClientException(error: 'Erro'));

      //Act
      final call = repository.fetchUserData;

      //Assert
      expect(call(), throwsA(isA<Failure>()));
      verify(
        () => mockRestClient.get<Map<String, dynamic>>(
          any(),
        ),
      ).called(1);
      verifyNever(() => mockLocalStorage.write<String>(any(), any()));
    });
  });

  group('Group test updateUserName', () {
    test('Should update user with success', () async {
      // Arrange
      const mockData = <String, dynamic>{'nome': 'Test'};
      when(
        () => mockRestClient.put(
          any(),
          data: mockData,
        ),
      ).thenAnswer(
        (_) async => MockRestClientResponse(
          statusCode: 200,
          data: <String, dynamic>{
            'message': 'Nome do usu??rio atualizado com sucesso'
          },
        ),
      );
      //Act
      await repository.updateUserName(1, 'Test');

      //Assert
      verify(
        () => mockRestClient.put(
          any(),
          data: mockData,
        ),
      ).called(1);
    });

    test('Should update user throws exception', () async {
      // Arrange
      const mockData = <String, dynamic>{'nome': 'Test'};
      when(
        () => mockRestClient.put(
          any(),
          data: mockData,
        ),
      ).thenThrow(RestClientException(error: 'Erro'));

      //Act
      final call = repository.updateUserName;

      //Assert
      expect(call(1, 'Test'), throwsA(isA<Failure>()));
      verify(
        () => mockRestClient.put(
          any(),
          data: mockData,
        ),
      ).called(1);
    });
  });

  group('Group test remove local user', () {
    test('Should remove user with success', () async {
      //Arrange
      when(() => mockLocalStorage.remove(any())).thenAnswer((_) async => _);

      //Act
      await repository.removeLocalUserData();

      //Assert
      verify(() => mockLocalStorage.remove(any())).called(1);
    });
  });
}
