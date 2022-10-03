import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:provider/provider.dart';

class MockCategoriesControllerImpl extends Mock
    implements CategoriesControllerImpl {}

class MockExpensesControllerImpl extends Mock
    implements ExpensesControllerImpl {}

class MockHomeControllerImpl extends Mock implements HomeControllerImpl {}

class MockUserControllerImpl extends Mock implements UserControllerImpl {}

void main() {
  late CategoriesControllerImpl mockCategoriesControllerImpl;
  late ExpensesControllerImpl mockExpensesControllerImpl;
  late HomeControllerImpl mockHomeControllerImpl;
  late UserControllerImpl mockUserControllerImpl;

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
        ChangeNotifierProvider<UserControllerImpl>(
          create: (context) => mockUserControllerImpl,
        ),
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
        builder: (context, child) => MaterialApp(
          initialRoute: CategoriesPage.router,
          theme: UiConfig.themeLight,
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
    mockUserControllerImpl = MockUserControllerImpl();
  });

  testWidgets('Must test list scrolling', (tester) async {
    when(() => mockCategoriesControllerImpl.findCategories(any()))
        .thenAnswer((_) async => _);

    when(() => mockCategoriesControllerImpl.categoriesList)
        .thenReturn(mockCategoriesList);

    when(() => mockUserControllerImpl.user).thenReturn(
      const UserModel(
        userId: 1,
        name: 'Test',
        email: 'test@domain.com',
        firebaseUserId: '123456',
      ),
    );

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
}
