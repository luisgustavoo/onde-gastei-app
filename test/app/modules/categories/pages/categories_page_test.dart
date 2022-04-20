import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:provider/provider.dart';

class MockCategoriesControllerImpl extends Mock
    implements CategoriesControllerImpl {}

class MockExpensesControllerImpl extends Mock
    implements ExpensesControllerImpl {}

class MockHomeControllerImpl extends Mock implements HomeControllerImpl {}

void main() {
  late CategoriesControllerImpl mockCategoriesControllerImpl;
  late ExpensesControllerImpl mockExpensesControllerImpl;
  late HomeControllerImpl mockHomeControllerImpl;

  final mockCategoriesList = List<CategoryModel>.generate(
    100,
    (index) => CategoryModel(
      id: index,
      description: 'Test $index',
      iconCode: 58261,
      colorCode: 4284513675,
      userId: 1,
    ),
  );

  final dateFilter = DateFilter(
    initialDate: DateTime(DateTime.now().year, DateTime.now().month),
    finalDate: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(
      const Duration(days: 1),
    ),
  );

  Widget createCategoriesPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeControllerImpl>(
          create: (context) => mockHomeControllerImpl,
        ),
        ChangeNotifierProvider<ExpensesControllerImpl>(
          create: (context) => mockExpensesControllerImpl,
        ),
        ChangeNotifierProvider<CategoriesControllerImpl>(
          create: (context) => mockCategoriesControllerImpl,
        ),
      ],
      child: ScreenUtilInit(
        builder: () => MaterialApp(
          initialRoute: CategoriesPage.router,
          routes: {
            CategoriesPage.router: (context) => CategoriesPage(
                  categoriesController: mockCategoriesControllerImpl,
                  expensesController: mockExpensesControllerImpl,
                  homeController: mockHomeControllerImpl,
                  dateFilter: dateFilter,
                ),
          },
        ),
      ),
    );
  }

  setUp(() {
    mockCategoriesControllerImpl = MockCategoriesControllerImpl();
    mockHomeControllerImpl = MockHomeControllerImpl();
    mockExpensesControllerImpl = MockExpensesControllerImpl();
  });

  group('Group test categories page', () {
    testWidgets('Test if categories page shows up', (tester) async {
      when(() => mockCategoriesControllerImpl.findCategories(any()))
          .thenAnswer((_) async => _);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(CategoriesState.success);

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
          .thenReturn(mockCategoriesList);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(CategoriesState.loading);

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
          .thenReturn(mockCategoriesList);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(CategoriesState.error);

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
          .thenReturn(mockCategoriesList);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(CategoriesState.success);

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
