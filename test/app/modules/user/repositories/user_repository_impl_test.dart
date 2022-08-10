import 'dart:convert';

import 'package:firebase_performance/firebase_performance.dart';
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
import '../../../../core/log/mock_metrics_monitor.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

class MockLocalStorage extends Mock
    implements SharedPreferencesLocalStorageImpl {}

void main() {
  late RestClient mockRestClient;
  late Log mockLog;
  late UserRepository repository;
  late LocalStorage mockLocalStorage;
  late MockMetricsMonitor metricsMonitor;
  late Trace trace;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    mockRestClient = MockRestClient();
    mockLog = MockLog();
    metricsMonitor = MockMetricsMonitor();
    trace = MockTrace();
    repository = UserRepositoryImpl(
      restClient: mockRestClient,
      log: mockLog,
      localStorage: mockLocalStorage,
      metricsMonitor: metricsMonitor,
    );

    when(() => metricsMonitor.addTrace(any())).thenAnswer((_) => trace);
    when(() => metricsMonitor.startTrace(trace)).thenAnswer((_) async => _);
    when(() => metricsMonitor.stopTrace(trace)).thenAnswer((_) async => _);
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
      metricsMonitor.checkCalledMetrics(trace);
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
      await Future<void>.delayed(const Duration(milliseconds: 200));
      verify(
        () => mockRestClient.get<Map<String, dynamic>>(
          any(),
        ),
      ).called(1);
      verifyNever(() => mockLocalStorage.write<String>(any(), any()));
      metricsMonitor.checkCalledMetrics(trace);
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
      await Future<void>.delayed(const Duration(milliseconds: 200));
      verify(
        () => mockRestClient.get<Map<String, dynamic>>(
          any(),
        ),
      ).called(1);
      verifyNever(() => mockLocalStorage.write<String>(any(), any()));
      metricsMonitor.checkCalledMetrics(trace);
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
            'message': 'Nome do usuário atualizado com sucesso'
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

      metricsMonitor.checkCalledMetrics(trace);
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
      await Future<void>.delayed(const Duration(milliseconds: 200));
      verify(
        () => mockRestClient.put(
          any(),
          data: mockData,
        ),
      ).called(1);
      metricsMonitor.checkCalledMetrics(trace);
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
