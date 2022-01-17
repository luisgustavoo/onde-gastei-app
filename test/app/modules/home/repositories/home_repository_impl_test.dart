import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

import '../../../../core/fixture/fixture_reader.dart';
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
          'app/modules/home/repositories/fixture/get_data_by_token_success_response.json');
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

  group('Group test findTotalExpensesByCategories', () {
    test('Should findTotalExpensesByCategories with success', () async {
      // Arrange
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      final totalExpensesCategoriesExpected = TotalExpensesCategoriesViewModel(
        totalValue: 1,
        category: const CategoryModel(
            id: 1, description: 'Test', iconCode: 1, colorCode: 1),
      );

      final jsonData = FixtureReader.getJsonData(
          'app/modules/home/repositories/fixture/find_total_expenses_by_categories_response.json');
      final responseData = jsonDecode(jsonData) as List<dynamic>;
      final mockResponse =
          MockRestClientResponse(statusCode: 200, data: responseData);

      when(
        () => restClient.get<List<dynamic>>(
          any(),
          queryParameters: <String, dynamic>{
            'initial_date': initialDate,
            'final_date': finalDate
          },
        ),
      ).thenAnswer((_) async => mockResponse);
      //Act
      final totalExpensesCategories = await repository
          .findTotalExpensesByCategories(1, initialDate, finalDate);
      //Assert
      expect(totalExpensesCategories[0], totalExpensesCategoriesExpected);
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
            'final_date': finalDate
          },
        ),
      ).thenAnswer((_) async => mockResponse);
      //Act
      final totalExpensesCategories = await repository
          .findTotalExpensesByCategories(1, initialDate, finalDate);
      //Assert
      expect(totalExpensesCategories, <TotalExpensesCategoriesViewModel>[]);
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
            'final_date': finalDate
          },
        ),
      ).thenThrow(RestClientException(error: 'Error'));
      //Act
      final call = repository.findTotalExpensesByCategories;
      //Assert
      expect(() => call(1, initialDate, finalDate), throwsA(isA<Failure>()));
    });
  });
}
