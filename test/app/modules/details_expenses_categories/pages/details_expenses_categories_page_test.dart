import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/controllers/details_expenses_categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/pages/details_expenses_categories_page.dart';
import 'package:provider/provider.dart';

class MockDetailsExpensesCategoriesImpl extends Mock
    implements DetailsExpensesCategoriesControllerImpl {}

void main() {
  late DetailsExpensesCategoriesControllerImpl
      mockDetailsExpensesCategoriesControllerImpl;

  final dateFilter = DateFilter(
    initialDate: DateTime(DateTime.now().year, DateTime.now().month),
    finalDate: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(
      const Duration(days: 1),
    ),
  );

  Widget createDetailsExpensesCategoriesPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetailsExpensesCategoriesControllerImpl>(
          create: (context) => mockDetailsExpensesCategoriesControllerImpl,
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],
          initialRoute: DetailsExpensesCategoriesPage.router,
          routes: {
            DetailsExpensesCategoriesPage.router: (context) =>
                DetailsExpensesCategoriesPage(
                  userId: 1,
                  categoryId: 1,
                  categoryName: 'Test Category',
                  controller: mockDetailsExpensesCategoriesControllerImpl,
                  dateFilter: dateFilter,
                ),
          },
        ),
      ),
    );
  }

  final expensesByCategoryList = [
    ExpenseModel(
      description: 'Test Expenses',
      value: 1,
      date: dateFilter.initialDate,
      category: const CategoryModel(
        id: 1,
        description: 'Test Category',
        iconCode: 58261,
        colorCode: 4284513675,
        userId: 1,
      ),
    )
  ];

  setUp(() {
    mockDetailsExpensesCategoriesControllerImpl =
        MockDetailsExpensesCategoriesImpl();
  });

  group('Group test DetailsExpensesCategoriesPage', () {
    testWidgets('Test if DetailsExpensesCategoriesPage shows up ',
        (tester) async {
      // Arrange
      when(
        () => mockDetailsExpensesCategoriesControllerImpl
            .findExpensesByCategories(
          userId: any(named: 'userId'),
          categoryId: any(named: 'categoryId'),
          initialDate: dateFilter.initialDate,
          finalDate: dateFilter.finalDate,
        ),
      ).thenAnswer((_) async => expensesByCategoryList);

      when(() => mockDetailsExpensesCategoriesControllerImpl.state)
          .thenReturn(DetailsExpensesCategoriesState.idle);

      when(
        () => mockDetailsExpensesCategoriesControllerImpl
            .detailsExpensesCategoryList,
      ).thenAnswer((_) => expensesByCategoryList);
      //Act
      await tester.pumpWidget(createDetailsExpensesCategoriesPage());

      //Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Test Category'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Test if DetailsExpensesCategoriesPage show error ',
        (tester) async {
      // Arrange
      when(
        () => mockDetailsExpensesCategoriesControllerImpl
            .findExpensesByCategories(
          userId: any(named: 'userId'),
          categoryId: any(named: 'categoryId'),
          initialDate: dateFilter.initialDate,
          finalDate: dateFilter.finalDate,
        ),
      ).thenAnswer((_) async => expensesByCategoryList);

      when(() => mockDetailsExpensesCategoriesControllerImpl.state)
          .thenReturn(DetailsExpensesCategoriesState.error);

      when(
        () => mockDetailsExpensesCategoriesControllerImpl
            .detailsExpensesCategoryList,
      ).thenAnswer((_) => expensesByCategoryList);
      //Act
      await tester.pumpWidget(createDetailsExpensesCategoriesPage());

      //Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Test Category'), findsOneWidget);
      expect(find.text('Erro a buscar despesas por categoria'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('Test if DetailsExpensesCategoriesPage show loading ',
        (tester) async {
      // Arrange
      when(
        () => mockDetailsExpensesCategoriesControllerImpl
            .findExpensesByCategories(
          userId: any(named: 'userId'),
          categoryId: any(named: 'categoryId'),
          initialDate: dateFilter.initialDate,
          finalDate: dateFilter.finalDate,
        ),
      ).thenAnswer((_) async => expensesByCategoryList);

      when(() => mockDetailsExpensesCategoriesControllerImpl.state)
          .thenReturn(DetailsExpensesCategoriesState.loading);

      when(
        () => mockDetailsExpensesCategoriesControllerImpl
            .detailsExpensesCategoryList,
      ).thenAnswer((_) => expensesByCategoryList);
      //Act
      await tester.pumpWidget(createDetailsExpensesCategoriesPage());

      //Assert
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Test Category'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    });
  });
}
