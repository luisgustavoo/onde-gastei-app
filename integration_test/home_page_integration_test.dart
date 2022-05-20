import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/pages/home_page.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/widgets/indicador.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:provider/provider.dart';

class MockHomeControllerImpl extends Mock implements HomeControllerImpl {}

class MockUserControllerImpl extends Mock implements UserControllerImpl {}

class MockExpensesControllerImpl extends Mock
    implements ExpensesControllerImpl {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}

void main() {
  late HomeControllerImpl mockHomeControllerImpl;
  late ExpensesControllerImpl mockExpensesControllerImpl;
  late UserControllerImpl mockUserControllerImpl;
  late NavigatorObserver mockNavigatorObserver;

  final mockTotalExpensesCategoriesList =
      List<TotalExpensesCategoriesViewModel>.generate(
    100,
    (index) => TotalExpensesCategoriesViewModel(
      totalValue: double.parse(index.toString()),
      category: CategoryModel(
        id: index,
        description: 'Test $index',
        iconCode: 58261,
        colorCode: 4284513675,
        userId: 1,
      ),
    ),
  );

  final mockPercentageCategoriesList =
      List<PercentageCategoriesViewModel>.generate(
    100,
    (index) => PercentageCategoriesViewModel(
      value: double.parse(index.toString()),
      percentage: double.parse(index.toString()),
      category: CategoryModel(
        id: index,
        description: 'Test $index',
        iconCode: 58261,
        colorCode: 4284513675,
        userId: 1,
      ),
    ),
  );

  final dateFilter = DateFilter(
    initialDate: DateTime(2022),
    finalDate: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(
      const Duration(days: 1),
    ),
  );

  const userModel = UserModel(userId: 1, name: 'Test', email: 'test@doman.com');

  Widget createHomePage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeControllerImpl>(
          create: (context) => mockHomeControllerImpl,
        ),
        ChangeNotifierProvider<ExpensesControllerImpl>(
          create: (context) => mockExpensesControllerImpl,
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          theme: UiConfig.theme,
          navigatorObservers: [mockNavigatorObserver],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],
          initialRoute: HomePage.router,
          routes: {
            HomePage.router: (context) => HomePage(
                  homeController: mockHomeControllerImpl,
                  expensesController: mockExpensesControllerImpl,
                  dateFilter: dateFilter,
                ),
          },
        ),
      ),
    );
  }

  setUp(() {
    mockUserControllerImpl = MockUserControllerImpl();
    mockHomeControllerImpl = MockHomeControllerImpl();
    mockExpensesControllerImpl = MockExpensesControllerImpl();
    mockNavigatorObserver = MockNavigatorObserver();
    registerFallbackValue(MockRoute());
  });

  testWidgets('Test if home page shows up', (tester) async {
    when(() => mockUserControllerImpl.user).thenReturn(userModel);

    when(() => mockHomeControllerImpl.state).thenReturn(HomeState.idle);

    when(() => mockHomeControllerImpl.totalExpenses).thenReturn(1500);

    when(() => mockHomeControllerImpl.totalExpensesCategoriesList)
        .thenReturn(mockTotalExpensesCategoriesList);

    when(() => mockHomeControllerImpl.percentageCategoriesList)
        .thenReturn(mockPercentageCategoriesList);

    await tester.pumpWidget(createHomePage());

    expect(find.text('Olá, Test'), findsOneWidget);
    expect(
      find.text(
        '1.500,00',
      ),
      findsOneWidget,
    );
    expect(find.text('Período'), findsOneWidget);
    expect(find.text('01/01/2022'), findsOneWidget);
    expect(find.text('31/03/2022'), findsOneWidget);
    expect(find.byType(IconButton), findsWidgets);
    expect(find.byType(CircleAvatar), findsWidgets);
    expect(find.byType(PieChart), findsOneWidget);
    expect(find.byType(Indicator), findsWidgets);
  });

  // testWidgets('Test data filter on HomePage', (tester) async {
  //   userModel = UserModel(userId: 1, name: 'Test', email: 'test@doman.com');

  //   dateFilter = DateFilter(
  //     initialDate: DateTime(2022),
  //     finalDate: DateTime(
  //       DateTime.now().year,
  //       DateTime.now().month + 1,
  //     ).subtract(
  //       const Duration(days: 1),
  //     ),
  //   );
  //   //
  //   final currentMonth = DateTime.now().month;
  //   final currentYear = DateTime.now().year;

  //   when(() => mockHomeControllerImpl.state).thenReturn(HomeState.idle);

  //   when(() => mockHomeControllerImpl.totalExpenses).thenReturn(1500);

  //   when(() => mockHomeControllerImpl.totalExpensesCategoriesList)
  //       .thenReturn(mockTotalExpensesCategoriesList);

  //   when(() => mockHomeControllerImpl.percentageCategoriesList)
  //       .thenReturn(mockPercentageCategoriesList);

  //   when(
  //     () => mockHomeControllerImpl.fetchHomeData(
  //       userId: any(named: 'userId'),
  //       initialDate: any(named: 'initialDate'),
  //       finalDate: any(named: 'finalDate'),
  //     ),
  //   ).thenAnswer((_) async => _);

  //   when(
  //     () => mockExpensesControllerImpl.findExpensesByPeriod(
  //       userId: any(named: 'userId'),
  //       initialDate: any(named: 'initialDate'),
  //       finalDate: any(named: 'finalDate'),
  //     ),
  //   ).thenAnswer((_) async => _);

  //   final buttonDateFilter = find.byKey(const Key('date_filter_key_home_page'));

  //   final applyButton = find.byKey(
  //     const Key('apply_button_key_home_page'),
  //   );

  //   final initialDateFilter = find.byKey(
  //     const Key('initial_date_filter_key_home_page'),
  //   );
  //   final finalDateFilter = find.byKey(
  //     const Key('final_date_filter_key_home_page'),
  //   );

  //   await tester.pumpWidget(createHomePage());

  //   await tester.tap(buttonDateFilter);
  //   await tester.pumpAndSettle();

  //   expect(find.byType(OndeGasteiTextForm), findsNWidgets(2));
  //   expect(find.byType(OndeGasteiButton), findsOneWidget);
  //   expect(
  //     find.widgetWithText(OndeGasteiTextForm, 'Data Inicial'),
  //     findsOneWidget,
  //   );
  //   expect(
  //     find.widgetWithText(OndeGasteiTextForm, 'Data Final'),
  //     findsOneWidget,
  //   );

  //   // Inicio Data Inicial
  //   await tester.tap(initialDateFilter.last);
  //   await tester.pumpAndSettle();

  //   expect(find.byType(Dialog), findsOneWidget);

  //   // final firstDayMonth = find.descendant(
  //   //   of: find.byType(GridView),
  //   //   matching: find.widgetWithText(Container, '1'),
  //   // );

  //   final firstDayMonth = find.text('1');

  //   expect(
  //     firstDayMonth,
  //     findsOneWidget,
  //   );

  //   await tester.tap(firstDayMonth);
  //   await tester.pumpAndSettle();

  //   await tester.tap(find.widgetWithText(TextButton, 'Ok'));
  //   await tester.pumpAndSettle();

  //   expect(find.byType(Dialog), findsNothing);

  //   expect(
  //     find.descendant(
  //       of: find.byType(OndeGasteiTextForm),
  //       matching: find.text(
  //         DateFormat.yMd('pt_BR').format(
  //           DateTime(currentYear, currentMonth),
  //         ),
  //       ),
  //     ),
  //     findsOneWidget,
  //   );

  //   expect(dateFilter!.initialDate, DateTime(currentYear, currentMonth));
  //   // Fim Data Inicial

  //   // Data Final
  //   await tester.tap(finalDateFilter.last);
  //   await tester.pumpAndSettle();

  //   // final lastDayMonth = find.descendant(
  //   //   of: find.byType(GridView),
  //   //   matching: find.widgetWithText(Container, '28'),
  //   // );

  //   final lastDayMonth = find.text('28');

  //   expect(
  //     lastDayMonth,
  //     findsOneWidget,
  //   );

  //   await tester.tap(lastDayMonth);
  //   await tester.pumpAndSettle();

  //   await tester.tap(find.widgetWithText(TextButton, 'Ok'));
  //   await tester.pumpAndSettle();

  //   expect(find.byType(Dialog), findsNothing);

  //   expect(
  //     find.descendant(
  //       of: find.byType(OndeGasteiTextForm),
  //       matching: find.text(
  //         DateFormat.yMd('pt_BR').format(
  //           DateTime(currentYear, currentMonth, 28),
  //         ),
  //       ),
  //     ),
  //     findsOneWidget,
  //   );

  //   expect(dateFilter!.finalDate, DateTime(currentYear, currentMonth, 28));
  //   // Fim Data Final

  //   await tester.tap(applyButton);
  //   await tester.pumpAndSettle();

  //   verify(
  //     () => Future.wait([
  //       mockHomeControllerImpl.fetchHomeData(
  //         userId: any(named: 'userId'),
  //         initialDate: any(named: 'initialDate'),
  //         finalDate: any(named: 'finalDate'),
  //       ),
  //       mockExpensesControllerImpl.findExpensesByPeriod(
  //         userId: any(named: 'userId'),
  //         initialDate: any(named: 'initialDate'),
  //         finalDate: any(named: 'finalDate'),
  //       )
  //     ]),
  //   ).called(1);
  // });
}
