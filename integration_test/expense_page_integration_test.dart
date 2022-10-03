import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/widgets/expenses_list_tile.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:provider/provider.dart';

class MockExpensesControllerImpl extends Mock
    implements ExpensesControllerImpl {}

class MockHomeControllerImpl extends Mock implements HomeControllerImpl {}

class MockUserControllerImpl extends Mock implements UserControllerImpl {}

void main() {
  late MockExpensesControllerImpl mockExpensesController;
  late MockHomeControllerImpl mockHomeControllerImpl;
  late UserControllerImpl mockUserControllerImpl;

  final dateFilter = DateFilter(
    initialDate: DateTime(DateTime.now().year, DateTime.now().month),
    finalDate: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(
      const Duration(days: 1),
    ),
  );

  final mockExpensesList = List<ExpenseModel>.generate(
    1000,
    (index) => ExpenseModel(
      expenseId: index,
      description: 'Expense $index',
      date: DateTime(DateTime.now().year),
      value: 1,
      local: 'Test',
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
        ChangeNotifierProvider<UserControllerImpl>(
          create: (context) => mockUserControllerImpl,
        ),
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
        builder: (context, child) => MaterialApp(
          theme: UiConfig.themeLight,
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
            ExpensesPage.router: (context) => ExpensesPage(
                  expensesController: mockExpensesController,
                  homeController: mockHomeControllerImpl,
                  dateFilter: dateFilter,
                ),
          },
        ),
      ),
    );
  }

  setUp(() {
    mockExpensesController = MockExpensesControllerImpl();
    mockHomeControllerImpl = MockHomeControllerImpl();
    mockUserControllerImpl = MockUserControllerImpl();
  });

  testWidgets('Must test list scrolling', (tester) async {
    when(() => mockExpensesController.state).thenReturn(ExpensesState.success);

    when(() => mockExpensesController.expensesList)
        .thenReturn(mockExpensesList);

    when(() => mockUserControllerImpl.user).thenReturn(
      const UserModel(
        userId: 1,
        name: 'Test',
        email: 'test@domain.com',
        firebaseUserId: '123456',
      ),
    );

    when(
      () =>
          mockExpensesController.totalValueByDay(DateTime(DateTime.now().year)),
    ).thenReturn(
      100,
    );

    await tester.pumpWidget(createExpensesPage());

    // final listFinder = find.byType(ListView).last;

    final listFinder = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );

    final itemFinder = find.descendant(
      of: find.byType(ExpensesListTile),
      matching: find.text('Expense 500'),
    );

    await tester.scrollUntilVisible(
      itemFinder,
      900,
      scrollable: listFinder,
    );

    // await tester.dragUntilVisible(
    //   itemFinder,
    //   find.byType(ListView),
    //   const Offset(0, -1000),
    // );

    // expect(itemFinder, findsOneWidget);
  });
}
