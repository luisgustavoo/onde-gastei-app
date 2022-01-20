import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

import '../../../../core/log/mock_log.dart';

class MockCategoriesServices extends Mock implements CategoriesService {}


void main() {
  late CategoriesService service;
  late Log log;
  late CategoriesController controller;

  setUp(() {
    service = MockCategoriesServices();
    log = MockLog();
    controller = CategoriesControllerImpl(service: service, log: log);
  });

  group('group test register', () {
    test('Should register category with success', () async {
      // Arrange
      const categoryModel =
      CategoryModel(id: 1, description: 'Test', iconCode: 1, colorCode: 1);

      when(() => service.register(categoryModel)).thenAnswer((_) async => _);
      //Act
      await controller.register(categoryModel);

      //Assert
      verify(() => service.register(categoryModel)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      const categoryModel =
      CategoryModel(id: 1, description: 'Test', iconCode: 1, colorCode: 1);

      when(() => service.register(categoryModel)).thenThrow(Exception());
      //Act
      final call = controller.register;

      //Assert
      expect(() => call(categoryModel), throwsA(isA<Failure>()));
      verify(() => service.register(categoryModel)).called(1);
    });
  });

  group('Group test updateCategory', () {
    test('Should update category with success', () async {
      // Arrange
      const categoryId = 1;
      const categoryInputModel =
      CategoryInputModel(description: 'Test', iconCode: 1, colorCode: 1);
      when(() => service.updateCategory(categoryId, categoryInputModel))
          .thenAnswer((_) async => _);
      //Act
      await controller.updateCategory(categoryId, categoryInputModel);

      //Assert
      verify(() => service.updateCategory(categoryId, categoryInputModel)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      const categoryId = 1;
      const categoryInputModel =
      CategoryInputModel(description: 'Test', iconCode: 1, colorCode: 1);
      when(() => service.updateCategory(categoryId, categoryInputModel)).thenThrow(Exception());
      //Act
      final call = controller.updateCategory;

      //Assert
      expect(() => call(categoryId, categoryInputModel), throwsA(isA<Failure>()));
      verify(() => service.updateCategory(categoryId, categoryInputModel)).called(1);
    });

  });
}
