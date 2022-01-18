import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository_impl.dart';

import '../../../../core/log/mock_log.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient restClient;
  late Log log;
  late CategoriesRepository repository;

  setUp(() {
    restClient = MockRestClient();
    log = MockLog();
    repository = CategoriesRepositoryImpl(restClient: restClient, log: log);
  });

  group('Group test register', () {
    test('Should register category with success', () async {
      // Arrange
      const category =
          CategoryModel(id: 1, description: 'Test', iconCode: 1, colorCode: 1);

      final mockData = <String, dynamic>{
        'descricao': category.description,
        'codigo_icone': category.iconCode,
        'codigo_cor': category.colorCode,
        'id_usuario': category.userId
      };

      when(() => restClient.post(any(), data: mockData))
          .thenAnswer((_) async => MockRestClientResponse(statusCode: 200));
      //Act
      await repository.register(category);

      //Assert
      verify(() => restClient.post(any(), data: mockData)).called(1);
    });
  });

  test('Should throws RestClientException', () async {
    // Arrange
    const category =
        CategoryModel(id: 1, description: 'Test', iconCode: 1, colorCode: 1);

    final mockData = <String, dynamic>{
      'descricao': category.description,
      'codigo_icone': category.iconCode,
      'codigo_cor': category.colorCode,
      'id_usuario': category.userId
    };

    when(() => restClient.post(any(), data: mockData))
        .thenThrow(RestClientException(error: 'Error'));
    //Act
    final call = repository.register;

    //Assert
    expect(() => call(category), throwsA(isA<Failure>()));
    verify(() => restClient.post(any(), data: mockData)).called(1);
  });
}
