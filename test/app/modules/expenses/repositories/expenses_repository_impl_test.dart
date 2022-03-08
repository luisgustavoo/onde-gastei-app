import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository_impl.dart';

import '../../../../core/log/mock_log.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient mockRestClient;
  late Log mockLog;
  late ExpensesRepositoryImpl expensesRepositoryImpl;

  final expenseModel = ExpenseModel(
    description: 'Test',
    date: DateTime.now(),
    value: 1,
    userId: 1,
    category: const CategoryModel(
      id: 1,
      description: 'Test',
      colorCode: 1,
      iconCode: 1,
      userId: 1,
    ),
  );

  setUp(() {
    mockRestClient = MockRestClient();
    mockLog = MockLog();
    expensesRepositoryImpl =
        ExpensesRepositoryImpl(restClient: mockRestClient, log: mockLog);
    registerFallbackValue(expenseModel);
  });

  group('Group test expenses register', () {
    test('Should register expenses with success', () async {
      //Arrange

      final data = <String, dynamic>{
        'descricao': expenseModel.description,
        'valor': expenseModel.value,
        'data': expenseModel.date.toIso8601String(),
        'id_usuario': expenseModel.userId,
        'id_categoria': expenseModel.category.id
      };

      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: data,
        ),
      ).thenAnswer((_) async => MockRestClientResponse(statusCode: 200));

      //Act
      await expensesRepositoryImpl.register(expenseModel);

      //Assert
      verify(
        () => mockRestClient.post<Map<String, dynamic>>(any(), data: data),
      ).called(1);
    });

    test('Should throws exception', () async {
      //Arrange
      final data = <String, dynamic>{
        'descricao': expenseModel.description,
        'valor': expenseModel.value,
        'data': expenseModel.date.toIso8601String(),
        'id_usuario': expenseModel.userId,
        'id_categoria': expenseModel.category.id
      };

      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: data,
        ),
      ).thenThrow(RestClientException(error: 'Error'));

      //Act
      final call = expensesRepositoryImpl.register;

      //Assert
      expect(() => call(expenseModel), throwsA(isA<Failure>()));
      verify(
        () => mockRestClient.post<Map<String, dynamic>>(any(), data: data),
      ).called(1);
    });
  });

  group('Group test expense update', () {
    test('Should update expense with success', () async {
      //Arrange
      // final data = <String, dynamic>{
      //   'descricao': expenseModel.description,
      //   'valor': expenseModel.value,
      //   'data': expenseModel.date,
      //   'id_categoria': expenseModel.category.id
      // };

      when(
        () => mockRestClient.put<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => MockRestClientResponse(statusCode: 200));

      //Act
      await expensesRepositoryImpl.update(expenseModel, 1);

      //Assert
      verify(
        () => mockRestClient.put<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).called(1);
    });

    test('Should throws exception', () async {
      //Arrange
      // final data = <String, dynamic>{
      //   'descricao': expenseModel.description,
      //   'valor': expenseModel.value,
      //   'data': expenseModel.date,
      //   'id_categoria': expenseModel.category.id
      // };

      when(
        () => mockRestClient.put<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(RestClientException(error: 'Error'));

      //Act
      final call = expensesRepositoryImpl.update;

      //Assert
      expect(() => call(expenseModel, 1), throwsA(isA<Failure>()));
      verify(
        () => mockRestClient.put<Map<String, dynamic>>(any(), data: any(named: 'data')),
      ).called(1);
    });
  });

  group('Group test expense delete', () {
    test('Should delete expense with success', () async {
      //Arrange
      when(() => mockRestClient.delete<Map<String, dynamic>>(any())).thenAnswer(
        (_) async => MockRestClientResponse(statusCode: 200),
      );

      //Act
      await expensesRepositoryImpl.delete(1);

      //Asssert
      verify(
        () => mockRestClient.delete<Map<String, dynamic>>(any()),
      ).called(1);
    });

    test('Should throws exception', () async {
      //Arrange
      when(() => mockRestClient.delete<Map<String, dynamic>>(any())).thenThrow(
        RestClientException(error: 'Erro'),
      );

      //Act
      final call = expensesRepositoryImpl.delete;

      //Assert
      expect(() => call(1), throwsA(isA<Failure>()));
      verify(
        () => mockRestClient.delete<Map<String, dynamic>>(any()),
      ).called(1);
    });
  });
}
