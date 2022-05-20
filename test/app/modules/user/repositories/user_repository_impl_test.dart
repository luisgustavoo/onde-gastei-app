import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository_impl.dart';

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
    });
  });
}
