import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/view_models/expenses_input_model.dart';

import '../../../../core/log/mock_log.dart';
import '../../../../core/rest_client/mock_rest_client.dart';
import '../../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient mockRestClient;
  late Log mockLog;
  late ExpensesRepositoryImpl expensesRepositoryImpl;

  setUp(() {
    mockRestClient = MockRestClient();
    mockLog = MockLog();
    expensesRepositoryImpl =
        ExpensesRepositoryImpl(restClient: mockRestClient, log: mockLog);
    registerFallbackValue(ExpensesInputModel);
  });

  group('Group test exepenses register', () {
    test('Should resgister expenses with success', () async {
      //Arrange
      final expensesInputModel = ExpensesInputModel(
        description: 'Test',
        date: DateTime.now(),
        value: 1,
        userId: 1,
        categoryId: 1,
      );

      final data = <String, dynamic>{
        'descricao': expensesInputModel.description,
        'valor': expensesInputModel.value,
        'data': expensesInputModel.date,
        'id_usuario': expensesInputModel.userId,
        'id_categoria': expensesInputModel.categoryId
      };

      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: data,
        ),
      ).thenAnswer((_) async => MockRestClientResponse(statusCode: 200));

      //Act
      await expensesRepositoryImpl.register(expensesInputModel);

      //Assert
      verify(
        () => mockRestClient.post<Map<String, dynamic>>(any(), data: data),
      ).called(1);
    });

    test('Should throws exception', () async {
      //Arrange
      final expensesInputModel = ExpensesInputModel(
        description: 'Test',
        date: DateTime.now(),
        value: 1,
        userId: 1,
        categoryId: 1,
      );

      final data = <String, dynamic>{
        'descricao': expensesInputModel.description,
        'valor': expensesInputModel.value,
        'data': expensesInputModel.date,
        'id_usuario': expensesInputModel.userId,
        'id_categoria': expensesInputModel.categoryId
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
      expect(() => call(expensesInputModel), throwsA(isA<Failure>()));
      verify(
        () => mockRestClient.post<Map<String, dynamic>>(any(), data: data),
      ).called(1);
    });
  });

  group('Group test exepense update', () {
    test('Should update expense with success', () async {
      //Arrange
      final expensesInputModel = ExpensesInputModel(
        description: 'Test',
        date: DateTime.now(),
        value: 1,
        categoryId: 1,
      );

      final data = <String, dynamic>{
        'descricao': expensesInputModel.description,
        'valor': expensesInputModel.value,
        'data': expensesInputModel.date,
        'id_categoria': expensesInputModel.categoryId
      };

      when(
        () => mockRestClient.put<Map<String, dynamic>>(
          any(),
          data: data,
        ),
      ).thenAnswer((_) async => MockRestClientResponse(statusCode: 200));

      //Act
      await expensesRepositoryImpl.update(expensesInputModel, 1);

      //Assert
      verify(
        () => mockRestClient.put<Map<String, dynamic>>(any(), data: data),
      ).called(1);
    });

    test('Should throws exception', () async {
      //Arrange
      final expensesInputModel = ExpensesInputModel(
        description: 'Test',
        date: DateTime.now(),
        value: 1,
        categoryId: 1,
      );

      final data = <String, dynamic>{
        'descricao': expensesInputModel.description,
        'valor': expensesInputModel.value,
        'data': expensesInputModel.date,
        'id_categoria': expensesInputModel.categoryId
      };

      when(
        () => mockRestClient.put<Map<String, dynamic>>(
          any(),
          data: data,
        ),
      ).thenThrow(RestClientException(error: 'Error'));

      //Act
      final call = expensesRepositoryImpl.update;

      //Assert
      expect(() => call(expensesInputModel, 1), throwsA(isA<Failure>()));
      verify(
        () => mockRestClient.put<Map<String, dynamic>>(any(), data: data),
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

      //Asssert
      expect(() => call(1), throwsA(isA<Failure>()));
      verify(
        () => mockRestClient.delete<Map<String, dynamic>>(any()),
      ).called(1);
    });
  });
}
