import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

import '../../../../core/local_storage/mock_local_storage.dart';

class MockHomeService extends Mock implements HomeService {}

void main() {
  late HomeService service;
  late LocalStorage localStorage;
  late HomeController controller;

  setUp(() {
    service = MockHomeService();
    localStorage = MockLocalStorage();
    controller = HomeControllerImpl(
      service: service,
      localStorage: localStorage,
    );
  });

  group('group test fetchHomeData', () {
    test('Should fetchHomeData with success', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      final totalExpensesCategoriesExpected = [
        TotalExpensesCategoriesViewModel(
          totalValue: 1,
          category: const CategoryModel(
            id: 1,
            description: 'Test',
            iconCode: 1,
            colorCode: 1,
          ),
        )
      ];

      final percentageCategoriesExpected = [
        const PercentageCategoriesViewModel(
          value: 1,
          percentage: 1,
          category: CategoryModel(
            id: 1,
            description: 'Test',
            iconCode: 1,
            colorCode: 1,
          ),
        )
      ];

      when(() => service.findTotalExpensesByCategories(any(), any(), any()))
          .thenAnswer((_) async => totalExpensesCategoriesExpected);
      when(() => service.findPercentageByCategories(any(), any(), any()))
          .thenAnswer((_) async => percentageCategoriesExpected);

      //Act
      await controller.fetchHomeData(
        userId: userId,
        initialDate: initialDate,
        finalDate: finalDate,
      );

      //Assert
      verify(() => service.findTotalExpensesByCategories(any(), any(), any()))
          .called(1);
      verify(() => service.findPercentageByCategories(any(), any(), any()))
          .called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();
      when(() => service.findTotalExpensesByCategories(any(), any(), any()))
          .thenThrow(Exception());
      //Act
      final call = controller.fetchHomeData;

      //Assert
      expect(
        () => call(
          userId: userId,
          initialDate: initialDate,
          finalDate: finalDate,
        ),
        throwsA(isA<Failure>()),
      );

      verifyNever(
        () => service.findPercentageByCategories(any(), any(), any()),
      );
    });
  });

  group('Group test fetchUserData', () {
    test('Should fetchUserData with success', () async {
      // Arrange
      final userExpected =
          UserModel(userId: 1, name: 'Test', email: 'test@domain.com');

      when(() => localStorage.read<String>(any()))
          .thenAnswer((_) async => jsonEncode(userExpected.toMap()));
      //Act
      final user = await controller.fetchUserData();

      //Assert
      expect(user, userExpected);
      verify(() => localStorage.read<String>(any())).called(1);
    });

    test('Should local user is empty', () async {
      // Arrange
      final userExpected =
          UserModel(userId: 1, name: 'Test', email: 'test@domain.com');

      when(() => localStorage.read<String>(any())).thenAnswer((_) async => '');
      when(() => service.fetchUserData()).thenAnswer((_) async => userExpected);
      //Act
      final user = await controller.fetchUserData();

      //Assert
      expect(user, userExpected);
      verify(() => localStorage.read<String>(any())).called(1);
      verify(() => service.fetchUserData()).called(1);
    });

    test('Should local user is null', () async {
      // Arrange
      final userExpected =
          UserModel(userId: 1, name: 'Test', email: 'test@domain.com');

      when(() => localStorage.read<String>(any()))
          .thenAnswer((_) async => null);
      when(() => service.fetchUserData()).thenAnswer((_) async => userExpected);
      //Act
      final user = await controller.fetchUserData();

      //Assert
      expect(user, userExpected);
      verify(() => localStorage.read<String>(any())).called(1);
      verify(() => service.fetchUserData()).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => localStorage.read<String>(any())).thenThrow(Exception());

      //Act
      final call = controller.fetchUserData;

      //Assert
      expect(call, throwsA(isA<Failure>()));
      verifyNever(() => service.fetchUserData());
    });
  });
}
