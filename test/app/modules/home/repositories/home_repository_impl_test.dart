import 'dart:convert';

import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

import '../../../../core/fixture/fixture_reader.dart';
import '../../../../core/log/mock_log.dart';
import '../../../../core/log/mock_metrics_monitor.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient restClient;
  late Log log;
  late HomeRepositoryImpl repository;
  late MockMetricsMonitor metricsMonitor;
  late Trace trace;

  setUp(() {
    log = MockLog();
    restClient = MockRestClient();
    metricsMonitor = MockMetricsMonitor();
    trace = MockTrace();
    repository = HomeRepositoryImpl(
      restClient: restClient,
      log: log,
      metricsMonitor: metricsMonitor,
    );

    metricsMonitor.mockCalledMetrics(trace);
  });

  group('Group test findTotalExpensesByCategories', () {
    test('Should findTotalExpensesByCategories with success', () async {
      // Arrange
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      const totalExpensesCategoriesExpected = TotalExpensesCategoriesViewModel(
        totalValue: 1,
        category: CategoryModel(
          id: 1,
          description: 'Test',
          iconCode: 1,
          colorCode: 1,
        ),
      );

      final jsonData = FixtureReader.getJsonData(
        'app/modules/home/repositories/fixture/find_total_expenses_by_categories_response.json',
      );
      final responseData = jsonDecode(jsonData) as List<dynamic>;
      final mockResponse =
          MockRestClientResponse(statusCode: 200, data: responseData);

      when(
        () => restClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': initialDate,
            'final_date': finalDate,
          },
        ),
      ).thenAnswer((_) async => mockResponse);
      //Act
      final totalExpensesCategories = await repository
          .findTotalExpensesByCategories(1, initialDate, finalDate);
      //Assert
      expect(totalExpensesCategories[0], totalExpensesCategoriesExpected);
      metricsMonitor.checkCalledMetrics(trace);
    });

    test('Should return empty list', () async {
      // Arrange
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      final mockResponse =
          MockRestClientResponse(statusCode: 200, data: <dynamic>[]);

      when(
        () => restClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': initialDate,
            'final_date': finalDate,
          },
        ),
      ).thenAnswer((_) async => mockResponse);
      //Act
      final totalExpensesCategories = await repository
          .findTotalExpensesByCategories(1, initialDate, finalDate);
      //Assert
      expect(totalExpensesCategories, <TotalExpensesCategoriesViewModel>[]);
      metricsMonitor.checkCalledMetrics(trace);
    });

    test('Should throws RestClientException', () async {
      // Arrange
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => restClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': initialDate,
            'final_date': finalDate,
          },
        ),
      ).thenThrow(RestClientException(error: 'Error'));
      //Act
      final call = repository.findTotalExpensesByCategories;
      //Assert
      expect(() => call(1, initialDate, finalDate), throwsA(isA<Failure>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      metricsMonitor.checkCalledMetrics(trace);
    });
  });

  group('Group test findPercentageByCategories', () {
    test('Should findPercentageByCategories with success', () async {
      // Arrange
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      const percentageCategoriesExpected = PercentageCategoriesViewModel(
        value: 1,
        percentage: 1,
        category: CategoryModel(
          id: 1,
          description: 'Test',
          iconCode: 1,
          colorCode: 1,
        ),
      );

      final jsonData = FixtureReader.getJsonData(
        'app/modules/home/repositories/fixture/find_percentage_by_categories_response.json',
      );
      final responseData = jsonDecode(jsonData) as List<dynamic>;
      final mockResponse =
          MockRestClientResponse(statusCode: 200, data: responseData);
      when(
        () => restClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': initialDate,
            'final_date': finalDate,
          },
        ),
      ).thenAnswer((_) async => mockResponse);
      //Act
      final percentageCategories = await repository.findPercentageByCategories(
        1,
        initialDate,
        finalDate,
      );
      //Assert
      expect(percentageCategories[0], percentageCategoriesExpected);
      metricsMonitor.checkCalledMetrics(trace);
    });

    test('Should return empty list', () async {
      // Arrange
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      final mockResponse =
          MockRestClientResponse(statusCode: 200, data: <dynamic>[]);
      when(
        () => restClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': initialDate,
            'final_date': finalDate,
          },
        ),
      ).thenAnswer((_) async => mockResponse);
      //Act
      final percentageCategories = await repository.findPercentageByCategories(
        1,
        initialDate,
        finalDate,
      );
      //Assert
      expect(percentageCategories, <PercentageCategoriesViewModel>[]);

      metricsMonitor.checkCalledMetrics(trace);
    });

    test('Should throws RestClientException ', () async {
      // Arrange
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => restClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': initialDate,
            'final_date': finalDate,
          },
        ),
      ).thenThrow(RestClientException(error: 'Error'));
      //Act
      final call = repository.findPercentageByCategories;
      //Assert
      expect(() => call(1, initialDate, finalDate), throwsA(isA<Failure>()));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      metricsMonitor.checkCalledMetrics(trace);
    });
  });
}
