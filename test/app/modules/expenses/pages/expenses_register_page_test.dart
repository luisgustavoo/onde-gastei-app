import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:provider/provider.dart';

late ExpensesControllerImpl mockExpensesControllerImpl;

late CategoriesControllerImpl mockCategoriesControllerImpl;

class MockCategoriesControllerImpl extends Mock
    implements CategoriesControllerImpl {}

class MockExpensesControllerImpl extends Mock
    implements ExpensesControllerImpl {}

class MockCategoryModel extends Mock implements CategoryModel {}

bool isEditing = false;

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

final expenseModel = ExpenseModel(
  expenseId: 1,
  description: 'Supermercado BH',
  value: 1,
  date: DateTime.now(),
  category: const CategoryModel(
    id: 1,
    description: 'Test 1',
    iconCode: 58261,
    colorCode: 4284513675,
    userId: 1,
  ),
  userId: 1,
);

Widget createExpensesRegisterPage() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => mockCategoriesControllerImpl),
      ChangeNotifierProvider(create: (context) => mockExpensesControllerImpl),
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
        initialRoute: ExpensesRegisterPage.router,
        routes: {
          ExpensesRegisterPage.router: (context) {
            if (isEditing) {
              return ExpensesRegisterPage(
                expenseModel: expenseModel,
                isEditing: isEditing,
              );
            }
            return const ExpensesRegisterPage();
          }
        },
      ),
    ),
  );
}

void main() {
  setUp(() {
    mockExpensesControllerImpl = MockExpensesControllerImpl();
    mockCategoriesControllerImpl = MockCategoriesControllerImpl();
    registerFallbackValue(MockCategoryModel());
  });

  group('Group test ExpensesRegisterPage', () {
    testWidgets('Test if register expense page shows up', (tester) async {
      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      await tester.pumpWidget(createExpensesRegisterPage());

      final initialDate = DateFormat.yMd('pt_BR').format(
        DateTime.now(),
      );

      final initialValue = NumberFormat.currency(
        locale: 'pt-BR',
        symbol: r'R$',
        decimalDigits: 2,
      ).format(0);

      expect(find.text('Despesa'), findsOneWidget);

      expect(find.byIcon(Icons.close), findsOneWidget);

      expect(
        find.widgetWithText(OndeGasteiTextForm, 'Descrição'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(OndeGasteiTextForm, initialValue),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(OndeGasteiTextForm, initialDate),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
          DropdownButtonFormField<CategoryModel>,
          'Selecione a categoria',
        ),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(OndeGasteiButton, 'Salvar'),
        findsOneWidget,
      );

      expect(
        find.widgetWithText(OndeGasteiTextForm, initialDate),
        findsOneWidget,
      );
    });

    testWidgets('Should TextFormFields is empty', (tester) async {
      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      await tester.pumpWidget(createExpensesRegisterPage());

      final description = find.byKey(
        const Key('description_key_expenses_register_page'),
      );

      final value = find.byKey(
        const Key('value_key_expenses_register_page'),
      );

      final date = find.byKey(
        const Key('date_key_expenses_register_page'),
      );

      final registerButton = find.byKey(
        const Key('register_button_key_expenses_register_page'),
      );

      await tester.enterText(description, '');
      await tester.enterText(value, '');
      await tester.enterText(date, '');
      await tester.pumpAndSettle();

      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Informe a descrição'), findsOneWidget);
      expect(find.text('Informe o valor'), findsOneWidget);
      expect(find.text('Informe a data'), findsOneWidget);
      expect(find.text('Informe a categoria'), findsOneWidget);
    });

    testWidgets('Should date e value invalid', (tester) async {
      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      await tester.pumpWidget(createExpensesRegisterPage());

      final description = find.byKey(
        const Key('description_key_expenses_register_page'),
      );

      final value = find.byKey(
        const Key('value_key_expenses_register_page'),
      );

      final date = find.byKey(
        const Key('date_key_expenses_register_page'),
      );

      final registerButton = find.byKey(
        const Key('register_button_key_expenses_register_page'),
      );

      await tester.enterText(description, 'Test');
      await tester.enterText(value, 'a');
      await tester.enterText(date, '01/01/0001');
      await tester.pumpAndSettle();

      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Valor invalido'), findsOneWidget);
      expect(find.text('Data inválida'), findsOneWidget);
    });

    testWidgets('Should register expenses with success', (tester) async {
      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      when(
        () => mockExpensesControllerImpl.register(
          description: any<String>(named: 'description'),
          value: any<double>(named: 'value'),
          date: any<DateTime>(named: 'date'),
          category: any<CategoryModel>(named: 'category'),
          userId: 0,
        ),
      ).thenAnswer((_) async => _);

      await tester.pumpWidget(createExpensesRegisterPage());

      final description = find.byKey(
        const Key('description_key_expenses_register_page'),
      );

      final value = find.byKey(
        const Key('value_key_expenses_register_page'),
      );

      final date = find.byKey(
        const Key('date_key_expenses_register_page'),
      );

      final categories = find.byKey(
        const Key('categories_key_expenses_register_page'),
      );

      // final categoryItem = find.byKey(
      //   const Key('list_tile_item_key_0_expenses_register_page'),
      // );

      final registerButton = find.byKey(
        const Key('register_button_key_expenses_register_page'),
      );

      await tester.enterText(description, 'Test');
      await tester.enterText(value, r'R$ 1,00');
      await tester.enterText(date, '01/01/2022');
      await tester.tap(categories);
      await tester.pumpAndSettle();

      expect(find.byType(DropdownMenuItem<CategoryModel>), findsWidgets);

      await tester.tap(find.byType(DropdownMenuItem<CategoryModel>).last);
      // await tester.tap(categoryItem.last);
      await tester.pumpAndSettle();

      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Despesa registrada com sucesso!'), findsOneWidget);
    });

    testWidgets('Should throws exception when register expenses',
        (tester) async {
      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      when(
        () => mockExpensesControllerImpl.register(
          description: any<String>(named: 'description'),
          value: any<double>(named: 'value'),
          date: any<DateTime>(named: 'date'),
          category: any<CategoryModel>(named: 'category'),
          userId: 0,
        ),
      ).thenThrow(Failure());

      await tester.pumpWidget(createExpensesRegisterPage());

      final description = find.byKey(
        const Key('description_key_expenses_register_page'),
      );

      final value = find.byKey(
        const Key('value_key_expenses_register_page'),
      );

      final date = find.byKey(
        const Key('date_key_expenses_register_page'),
      );

      final categories = find.byKey(
        const Key('categories_key_expenses_register_page'),
      );

      final registerButton = find.byKey(
        const Key('register_button_key_expenses_register_page'),
      );

      await tester.enterText(description, 'Test');
      await tester.enterText(value, r'R$ 1,00');
      await tester.enterText(date, '01/01/2022');
      await tester.tap(categories);
      await tester.pumpAndSettle();

      expect(find.byType(DropdownMenuItem<CategoryModel>), findsWidgets);

      await tester.tap(find.byType(DropdownMenuItem<CategoryModel>).last);
      await tester.pumpAndSettle();

      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Erro ao registrar despesa!'), findsOneWidget);
    });

    testWidgets('Should update expenses with success', (tester) async {
      isEditing = true;
      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      when(
        () => mockExpensesControllerImpl.update(
          description: any<String>(named: 'description'),
          value: any<double>(named: 'value'),
          date: any<DateTime>(named: 'date'),
          category: any<CategoryModel>(named: 'category'),
          expenseId: any(named: 'expenseId'),
        ),
      ).thenAnswer((_) async => _);

      await tester.pumpWidget(createExpensesRegisterPage());

      final description = find.byKey(
        const Key('description_key_expenses_register_page'),
      );

      final registerButton = find.byKey(
        const Key('register_button_key_expenses_register_page'),
      );

      await tester.enterText(description, 'Test');
      await tester.pumpAndSettle();

      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Despesa atualizada com sucesso!'), findsOneWidget);
    });

    testWidgets('Should throw exception when updating expense', (tester) async {
      isEditing = true;
      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      when(
        () => mockExpensesControllerImpl.update(
          description: any<String>(named: 'description'),
          value: any<double>(named: 'value'),
          date: any<DateTime>(named: 'date'),
          category: any<CategoryModel>(named: 'category'),
          expenseId: any(named: 'expenseId'),
        ),
      ).thenThrow(Failure());

      await tester.pumpWidget(createExpensesRegisterPage());

      final description = find.byKey(
        const Key('description_key_expenses_register_page'),
      );

      final registerButton = find.byKey(
        const Key('register_button_key_expenses_register_page'),
      );

      await tester.enterText(description, 'Test');
      await tester.pumpAndSettle();

      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      expect(find.text('Erro ao atualizar despesa!'), findsOneWidget);
    });

    testWidgets('Should delete expense with success', (tester) async {
      isEditing = true;

      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockExpensesControllerImpl.deleteState)
          .thenReturn(expensesDeleteState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      when(
        () => mockExpensesControllerImpl.delete(
          expenseId: any(named: 'expenseId'),
        ),
      ).thenAnswer((_) async => _);

      await tester.pumpWidget(createExpensesRegisterPage());

      final deleteIcon = find.byKey(
        const Key('icon_delete_key_register_expenses_page'),
      );

      final deleteButtonDialog = find.byKey(
        const Key('delete_button_dialog_register_expenses_page'),
      );

      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(deleteButtonDialog);
      await tester.pumpAndSettle();

      expect(deleteButtonDialog, findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byWidget(createExpensesRegisterPage()), findsNothing);
    });

    testWidgets('Should delete expense with success', (tester) async {
      isEditing = true;

      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockExpensesControllerImpl.deleteState)
          .thenReturn(expensesDeleteState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      when(
        () => mockExpensesControllerImpl.delete(
          expenseId: any(named: 'expenseId'),
        ),
      ).thenAnswer((_) async => _);

      await tester.pumpWidget(createExpensesRegisterPage());

      final deleteIcon = find.byKey(
        const Key('icon_delete_key_register_expenses_page'),
      );

      final deleteButtonDialog = find.byKey(
        const Key('delete_button_dialog_register_expenses_page'),
      );

      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(deleteButtonDialog);
      await tester.pumpAndSettle();

      expect(deleteButtonDialog, findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byWidget(createExpensesRegisterPage()), findsNothing);
    });

    testWidgets('Should throws when delete expense', (tester) async {
      isEditing = true;

      when(() => mockExpensesControllerImpl.state)
          .thenReturn(expensesState.idle);

      when(() => mockExpensesControllerImpl.deleteState)
          .thenReturn(expensesDeleteState.idle);

      when(() => mockCategoriesControllerImpl.categoriesList)
          .thenReturn(mockCategoriesList);

      when(
        () => mockExpensesControllerImpl.delete(
          expenseId: any(named: 'expenseId'),
        ),
      ).thenThrow(Failure());

      await tester.pumpWidget(createExpensesRegisterPage());

      final deleteIcon = find.byKey(
        const Key('icon_delete_key_register_expenses_page'),
      );

      final deleteButtonDialog = find.byKey(
        const Key('delete_button_dialog_register_expenses_page'),
      );

      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      await tester.tap(deleteButtonDialog);
      await tester.pumpAndSettle();

      expect(find.text('Erro ao deletar despesa'), findsOneWidget);
    });
  });
}
