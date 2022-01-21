import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

import '../../../../core/fixture/fixture_reader.dart';
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
  });

  group('Group test updateCategory', () {
    test('Should update category with success', () async {
      // Arrange
      const categoryInputModel =
          CategoryInputModel(description: 'Test', iconCode: 1, colorCode: 1);

      final mockData = <String, dynamic>{
        'descricao': categoryInputModel.description,
        'codigo_icone': categoryInputModel.iconCode,
        'codigo_cor': categoryInputModel.colorCode
      };

      when(() => restClient.put(any(), data: mockData))
          .thenAnswer((_) async => MockRestClientResponse(statusCode: 200));
      //Act
      await repository.updateCategory(1, categoryInputModel);

      //Assert
      verify(() => restClient.put(any(), data: mockData)).called(1);
    });

    test('Should throws RestClientException', () async {
      // Arrange
      const categoryInputModel =
          CategoryInputModel(description: 'Test', iconCode: 1, colorCode: 1);

      final mockData = <String, dynamic>{
        'descricao': categoryInputModel.description,
        'codigo_icone': categoryInputModel.iconCode,
        'codigo_cor': categoryInputModel.colorCode
      };

      when(() => restClient.put(any(), data: mockData))
          .thenThrow(RestClientException(error: 'Error'));
      //Act
      final call = repository.updateCategory;

      //Assert
      expect(() => call(1, categoryInputModel), throwsA(isA<Failure>()));
      verify(() => restClient.put(any(), data: mockData)).called(1);
    });
  });

  group('Group test deleteCategory', () {
    test('Should delete category with success', () async {
      // Arrange
      when(() => restClient.delete<Map<String, dynamic>>(any()))
          .thenAnswer((_) async => MockRestClientResponse(statusCode: 200));
      //Act
      await repository.deleteCategory(1);

      //Assert
      verify(() => restClient.delete<Map<String, dynamic>>(any())).called(1);
    });

    test('Should throws RestClientException', () async {
      // Arrange
      when(() => restClient.delete<Map<String, dynamic>>(any()))
          .thenThrow(RestClientException(error: 'Error'));
      //Act
      final call = repository.deleteCategory;

      //Assert
      expect(() => call(1), throwsA(isA<Failure>()));
      verify(() => restClient.delete<Map<String, dynamic>>(any())).called(1);
    });
  });

  group('Group test findCategories', () {
    test('Should find categories with success', () async {
      //Arrange
      final jsonData = FixtureReader.getJsonData(
          'app/modules/categories/repositories/fixture/find_categories_response.json');
      final responseData = jsonDecode(jsonData) as List<dynamic>;

      final categoriesList = List<Map<String, dynamic>>.from(responseData);

      final categoriesModelExpected =
          categoriesList.map((c) => CategoryModel.fromMap(c)).toList();

      when(() => restClient.get<List<Map<String, dynamic>>>(any())).thenAnswer(
        (_) async =>
            MockRestClientResponse(statusCode: 200, data: categoriesList),
      );

      //Act
      final categoriesModel = await repository.findCategories(1);

      //Assert
      expect(categoriesModel, categoriesModelExpected);
      verify(() => restClient.get<List<Map<String, dynamic>>>(any())).called(1);
    });

    test('Should return categories empty', () async {
      //Arrange
      when(() => restClient.get<List<Map<String, dynamic>>>(any())).thenAnswer(
        (_) async => MockRestClientResponse(statusCode: 200, data: null),
      );

      //Act
      final categoriesModel = await repository.findCategories(1);

      //Assert
      expect(categoriesModel, <CategoryModel>[]);
    });

    test('Should throws exception', () async {
      //Arrange
      when(() => restClient.get<List<Map<String, dynamic>>>(any()))
          .thenThrow(Exception());

      //Act
      final call = repository.findCategories;

      //Assert
      expect(() => call(1), throwsA(isA<Failure>()));
    });
  });
}
