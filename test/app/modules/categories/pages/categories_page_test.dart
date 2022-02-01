import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:provider/provider.dart';

late CategoriesControllerImpl mockCategoriesControllerImpl;

class MockCategoriesControllerImpl extends Mock
    implements CategoriesControllerImpl {}

Widget createCategoriesPage() {
  return ChangeNotifierProvider<CategoriesControllerImpl>(
    create: (context) => mockCategoriesControllerImpl,
    child: ScreenUtilInit(
      builder: () => MaterialApp(
        initialRoute: CategoriesPage.router,
        routes: {
          CategoriesPage.router: (context) => const CategoriesPage(),
        },
      ),
    ),
  );
}

final categoriesList = List<CategoryModel>.generate(
  100,
  (index) => CategoryModel(
    id: index,
    description: 'Test $index',
    iconCode: 58261,
    colorCode: 4284513675,
    userId: 1,
  ),
);

void main() {
  setUp(() {
    mockCategoriesControllerImpl = MockCategoriesControllerImpl();
  });

  group('Group test categories page', () {
    testWidgets('Test if categories page shows up', (tester) async {
      when(() => mockCategoriesControllerImpl.findCategories(any()))
          .thenAnswer((_) async => _);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(categoriesList);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.success);

      await tester.pumpWidget(createCategoriesPage());

      await mockCategoriesControllerImpl.findCategories(1);

      expect(find.text('Categorias'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('Should show categories page loading', (tester) async {
      when(() => mockCategoriesControllerImpl.findCategories(any()))
          .thenAnswer((_) async => _);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(categoriesList);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.loading);

      await tester.pumpWidget(createCategoriesPage());

      await mockCategoriesControllerImpl.findCategories(1);

      expect(find.text('Categorias'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should show error when loading categories page',
        (tester) async {
      when(() => mockCategoriesControllerImpl.findCategories(any()))
          .thenAnswer((_) async => _);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(categoriesList);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.error);

      await tester.pumpWidget(createCategoriesPage());

      await mockCategoriesControllerImpl.findCategories(1);

      expect(find.text('Categorias'), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      expect(find.text('Erro ao buscar categorias'), findsOneWidget);
    });

    testWidgets('Must test list scrolling', (tester) async {
      when(() => mockCategoriesControllerImpl.findCategories(any()))
          .thenAnswer((_) async => _);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(categoriesList);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.success);

      await tester.pumpWidget(createCategoriesPage());

      await mockCategoriesControllerImpl.findCategories(1);

      final listFinder = find.byType(Scrollable);
      final itemFinder = find.text('Test 50');

      await tester.scrollUntilVisible(
        itemFinder,
        90,
        scrollable: listFinder,
      );

      expect(itemFinder, findsOneWidget);
    });
  });
}
