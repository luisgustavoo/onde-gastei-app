import 'dart:convert';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_response.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

import '../../../../core/fixture/fixture_reader.dart';
import '../../../../core/log/mock_log.dart';
import '../../../../core/log/mock_metrics_monitor.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient restClient;
  late Log log;
  late CategoriesRepository repository;
  late MetricsMonitor metricsMonitor;
  late Trace trace;

  setUp(() {
    restClient = MockRestClient();
    log = MockLog();
    metricsMonitor = MockMetricsMonitor();
    trace = MockTrace();
    repository = CategoriesRepositoryImpl(
      restClient: restClient,
      log: log,
      metricsMonitor: metricsMonitor,
    );

    when(() => metricsMonitor.addTrace(any())).thenAnswer((_) => trace);
    when(() => metricsMonitor.startTrace(trace)).thenAnswer((_) async => _);
    when(() => metricsMonitor.stopTrace(trace)).thenAnswer((_) async => _);
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
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
    });

    test('Should throws RestClientException', () async {
      // Arrange
      const category = CategoryModel(
        description: 'Test',
        iconCode: 1,
        colorCode: 1,
        userId: 1,
      );

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
      await Future<void>.delayed(const Duration(milliseconds: 200));
      verify(() => restClient.post(any(), data: mockData)).called(1);
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
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

      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
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
      await Future<void>.delayed(const Duration(milliseconds: 200));
      verify(() => restClient.put(any(), data: mockData)).called(1);
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
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
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
    });

    test('Should throws RestClientException', () async {
      // Arrange

      when(() => restClient.delete<Map<String, dynamic>>(any()))
          .thenThrow(RestClientException(error: 'Error'));
      //Act
      final call = repository.deleteCategory;

      //Assert
      expect(call(1), throwsA(isA<Failure>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      verify(() => restClient.delete<Map<String, dynamic>>(any())).called(1);
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
    });
  });

  group('Group test findCategories', () {
    test('Should find categories with success', () async {
      //Arrange
      final jsonData = FixtureReader.getJsonData(
        'app/modules/categories/repositories/fixture/find_categories_response.json',
      );
      final responseData = jsonDecode(jsonData) as List<dynamic>;

      final mockCategoriesList = List<Map<String, dynamic>>.from(responseData);

      final categoriesListExpected =
          mockCategoriesList.map(CategoryModel.fromMap).toList();

      when(() => restClient.get<List<dynamic>>(any())).thenAnswer(
        (_) async =>
            MockRestClientResponse(statusCode: 200, data: mockCategoriesList),
      );

      //Act
      final categoriesList = await repository.findCategories(1);

      //Assert
      expect(categoriesList, categoriesListExpected);
      verify(() => restClient.get<List<dynamic>>(any())).called(1);
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
    });

    test('Should return categories empty', () async {
      //Arrange
      when(() => restClient.get<List<dynamic>>(any())).thenAnswer(
        (_) async => MockRestClientResponse(
          statusCode: 200,
        ),
      );

      //Act
      final categoriesModel = await repository.findCategories(1);

      //Assert
      expect(categoriesModel, <CategoryModel>[]);
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
    });

    test('Should throws exception', () async {
      //Arrange
      when(() => restClient.get<List<dynamic>>(any())).thenThrow(Exception());

      //Act
      final call = repository.findCategories;

      //Assert
      expect(() => call(1), throwsA(isA<Failure>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
    });
  });

  group('Group test expenseQuantityByCategoryId', () {
    test('Should to fetch the amount of expenses from a category', () async {
      //Arrange
      when(() => restClient.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => RestClientResponse(
          statusCode: 200,
          data: <String, dynamic>{'quantidade': 1},
        ),
      );

      //Act
      final quantity = await repository.expenseQuantityByCategoryId(1);

      //Assert
      expect(quantity, 1);
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(1);
    });

    test('Should return null data', () async {
      //Arrange
      when(() => restClient.get<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => RestClientResponse(statusCode: 200),
      );

      //Act
      final call = repository.expenseQuantityByCategoryId;

      //Assert
      expect(() => call(1), throwsA(isA<Failure>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      verify(() => metricsMonitor.addTrace(any())).called(1);
      verify(() => metricsMonitor.startTrace(trace)).called(1);
      verify(() => metricsMonitor.stopTrace(trace)).called(2);
    });
  });
}
