import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/repositories/details_expenses_categories_repository_impl.dart';

import '../../../../core/fixture/fixture_reader.dart';
import '../../../../core/log/mock_log.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient mockRestClient;
  late Log mockLog;
  late DetailsExpensesCategoriesRepositoryImpl repository;

  setUp(() {
    mockRestClient = MockRestClient();
    mockLog = MockLog();
    repository = DetailsExpensesCategoriesRepositoryImpl(
      restClient: mockRestClient,
      log: mockLog,
    );
  });

  group('Group test Find Expenses By Categorias', () {
    test('Should return expenses by category with success', () async {
      // Arrange
      final dateFilter = DateFilter(
        initialDate: DateTime(2022, 03),
        finalDate: DateTime(2022, 03, 31),
      );

      final expensesCategoriesListExpected = [
        ExpenseModel(
          expenseId: 76,
          description: 'Livro Como Fazer Amigos e Influenciar Pessoas',
          value: 28,
          date: DateTime(2022, 03, 10),
          category: const CategoryModel(
            id: 110050,
            description: 'Compras',
            iconCode: 58266,
            colorCode: 4294924066,
          ),
        )
      ];

      final jsonData = FixtureReader.getJsonData(
        'app/modules/details_expenses_categories/repositories/fixture/find_expenses_by_categories_response.json',
      );
      final responseData = jsonDecode(jsonData) as List<dynamic>;
      final mockResponse =
          MockRestClientResponse(statusCode: 200, data: responseData);

      when(
        () => mockRestClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': dateFilter.initialDate.toIso8601String(),
            'final_date': dateFilter.finalDate.toIso8601String(),
          },
        ),
      ).thenAnswer(
        (_) async => mockResponse,
      );
      //Act
      final expensesCategoriesList = await repository.findExpensesByCategories(
        1,
        1,
        dateFilter.initialDate,
        dateFilter.finalDate,
      );

      //Assert
      expect(
        expensesCategoriesList.first,
        expensesCategoriesListExpected.first,
      );
    });

    test('Should return expenses by category empty', () async {
      // Arrange
      final dateFilter = DateFilter(
        initialDate: DateTime(2022, 03),
        finalDate: DateTime(2022, 03, 31),
      );

      final mockResponse =
          MockRestClientResponse<List<dynamic>>(statusCode: 200);

      when(
        () => mockRestClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': dateFilter.initialDate.toIso8601String(),
            'final_date': dateFilter.finalDate.toIso8601String(),
          },
        ),
      ).thenAnswer(
        (_) async => mockResponse,
      );
      //Act
      final expensesCategoriesList = await repository.findExpensesByCategories(
        1,
        1,
        dateFilter.initialDate,
        dateFilter.finalDate,
      );

      //Assert
      expect(expensesCategoriesList, <ExpenseModel>[]);
    });

    test('Should return throws exceptions', () async {
      // Arrange
      final dateFilter = DateFilter(
        initialDate: DateTime(2022, 03),
        finalDate: DateTime(2022, 03, 31),
      );

      when(
        () => mockRestClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': dateFilter.initialDate.toIso8601String(),
            'final_date': dateFilter.finalDate.toIso8601String(),
          },
        ),
      ).thenThrow(Exception());
      //Act
      final call = repository.findExpensesByCategories;

      //Assert
      expect(
        () => call(
          1,
          1,
          dateFilter.initialDate,
          dateFilter.finalDate,
        ),
        throwsA(isA<Failure>()),
      );
    });
  });
}
