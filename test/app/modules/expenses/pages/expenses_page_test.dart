import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/widgets/expenses_list_tile.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:provider/provider.dart';

late MockExpensesControllerImpl mockExpensesController;
late MockHomeControllerImpl mockHomeControllerImpl;

class MockExpensesControllerImpl extends Mock
    implements ExpensesControllerImpl {}

class MockHomeControllerImpl extends Mock implements HomeControllerImpl {}

final mockExpensesList = List<ExpenseModel>.generate(
  1000,
  (index) => ExpenseModel(
    expenseId: index,
    description: 'Expense $index',
    date: DateTime.now(),
    value: 1,
    category: CategoryModel(
      description: 'Category $index',
      iconCode: 58261,
      colorCode: 4284513675,
    ),
    userId: 1,
  ),
);

Widget createExpensesPage() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ExpensesControllerImpl>(
        create: (context) => mockExpensesController,
      ),
      ChangeNotifierProvider<HomeControllerImpl>(
        create: (context) => mockHomeControllerImpl,
      ),
    ],
    child: ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        initialRoute: ExpensesPage.router,
        routes: {
          ExpensesPage.router: (context) => const ExpensesPage(),
        },
      ),
    ),
  );
}

void main() {
  setUp(() {
    mockExpensesController = MockExpensesControllerImpl();
    mockHomeControllerImpl = MockHomeControllerImpl();
  });

  group('group test ExpensesPage', () {
    testWidgets('Test if expense page shows up', (tester) async {
      when(() => mockExpensesController.state).thenReturn(expensesState.idle);

      when(() => mockExpensesController.expensesList)
          .thenReturn(mockExpensesList);

      await tester.pumpWidget(createExpensesPage());

      expect(find.text('Pesquisar'), findsOneWidget);
      expect(find.text('Ordenar por'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ExpensesListTile), findsWidgets);
    });

    testWidgets('Should show error when loading expenses page', (tester) async {
      when(() => mockExpensesController.state).thenReturn(expensesState.error);

      await tester.pumpWidget(createExpensesPage());

      expect(find.text('Erro ao buscar despesas'), findsOneWidget);
    });

    testWidgets('Must test list scrolling', (tester) async {
      when(() => mockExpensesController.state)
          .thenReturn(expensesState.success);

      when(() => mockExpensesController.expensesList)
          .thenReturn(mockExpensesList);

      await tester.pumpWidget(createExpensesPage());

      // final listFinder = find.byType(Scrollable);
      final itemFinder = find.text('Expense 700');

      // await tester.scrollUntilVisible(
      //   itemFinder,
      //   999,
      //   scrollable: listFinder,
      // );

      await tester.dragUntilVisible(
        itemFinder,
        find.byType(ListView),
        const Offset(0, -999),
      );

      expect(itemFinder, findsOneWidget);
    });
  });
}
