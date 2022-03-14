import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_register_page.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';
import 'package:provider/provider.dart';

late CategoriesControllerImpl mockCategoriesControllerImpl;

bool isEditing = false;

class MockCategoriesControllerImpl extends Mock
    implements CategoriesControllerImpl {}

Widget createCategoriesRegisterPage() {
  return ChangeNotifierProvider<CategoriesControllerImpl>(
    create: (context) => mockCategoriesControllerImpl,
    child: ScreenUtilInit(
      builder: () => MaterialApp(
        initialRoute: CategoriesRegisterPage.router,
        routes: {
          CategoriesRegisterPage.router: (context) {
            if (isEditing) {
              return CategoriesRegisterPage(
                categoriesController: mockCategoriesControllerImpl,
                categoryModel: const CategoryModel(
                  description: 'Test',
                  iconCode: 1,
                  colorCode: 1,
                ),
                isEditing: isEditing,
              );
            }
            return CategoriesRegisterPage(
              categoriesController: mockCategoriesControllerImpl,
            );
          }
        },
      ),
    ),
  );
}

void main() {
  setUp(() {
    mockCategoriesControllerImpl = MockCategoriesControllerImpl();

    const categoryModel = CategoryModel(
      description: 'Test',
      iconCode: 1,
      colorCode: 1,
      userId: 1,
    );

    const categoryInputModel = CategoryInputModel(
      description: 'Test',
      iconCode: 1,
      colorCode: 1,
    );

    registerFallbackValue(categoryModel);
    registerFallbackValue(categoryInputModel);
  });

  group('Group test RegisterCategoriesPage ', () {
    testWidgets('Test if register categories page shows up', (tester) async {
      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      when(() => mockCategoriesControllerImpl.stateDelete)
          .thenReturn(categoriesDeleteState.idle);

      await tester.pumpWidget(createCategoriesRegisterPage());

      expect(find.text('Categoria'), findsOneWidget);
      expect(find.text('Ícone'), findsOneWidget);
      expect(find.text('Cor'), findsOneWidget);
      expect(
        find.widgetWithText(OndeGasteiTextForm, 'Categoria...'),
        findsOneWidget,
      );
      final buildIcon = find.byKey(
        const Key('build_icon_key_register_categories_page'),
      );
      final buildColor = find.byKey(
        const Key('build_color_key_register_categories_page'),
      );
      final saveButton =
          find.byKey(const Key('save_button_register_categories_page'));

      expect(
        find.widgetWithIcon(
          IconButton,
          Icons.close,
        ),
        findsOneWidget,
      );

      expect(buildIcon, findsOneWidget);
      expect(buildColor, findsOneWidget);
      expect(saveButton, findsOneWidget);

      // expect(find.widgetWithText(OndeGasteiButton, 'Salvar'), findsOneWidget);
    });

    testWidgets('Should TextFormField is empty', (tester) async {
      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      when(() => mockCategoriesControllerImpl.stateDelete)
          .thenReturn(categoriesDeleteState.idle);

      await tester.pumpWidget(createCategoriesRegisterPage());

      final categoryTextField = find.byKey(
        const Key('categories_key_register_categories'),
      );

      final saveButton = find.byKey(
        const Key('save_button_register_categories_page'),
      );

      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);

      await tester.enterText(categoryTextField, '');
      await tester.pump();

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('A categoria é obrigatório'), findsOneWidget);
    });

    testWidgets('Should create category with success', (tester) async {
      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      when(() => mockCategoriesControllerImpl.stateDelete)
          .thenReturn(categoriesDeleteState.idle);

      await tester.pumpWidget(createCategoriesRegisterPage());

      when(() => mockCategoriesControllerImpl.register(any()))
          .thenAnswer((_) async => _);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      final categoryTextField = find.byKey(
        const Key('categories_key_register_categories'),
      );

      final gestureIcon =
          find.byKey(const Key('gesture_icon_key_register_categories_page'));

      final gestureColor =
          find.byKey(const Key('gesture_color_key_register_categories_page'));

      final saveButton = find.byKey(
        const Key('save_button_register_categories_page'),
      );

      final iconsDialog =
          find.byKey(const Key('inkwell_icons_key_0_register_categories_page'));

      final colorsDialog =
          find.byKey(const Key('inkwell_color_key_0_register_categories_page'));

      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);

      await tester.enterText(categoryTextField, 'Test');
      await tester.pumpAndSettle();

      // Inserindo o ícone
      await tester.tap(gestureIcon);
      await tester.pumpAndSettle();

      expect(iconsDialog, findsOneWidget);

      await tester.tap(iconsDialog);
      await tester.pumpAndSettle();

      expect(iconsDialog, findsNothing);

      // Inserindo a cor
      await tester.tap(gestureColor);
      await tester.pumpAndSettle();

      expect(colorsDialog, findsOneWidget);

      await tester.tap(colorsDialog);
      await tester.pumpAndSettle();

      expect(colorsDialog, findsNothing);

      // Salvando registro
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Categoria criada com sucesso!'), findsOneWidget);
      verify(() => mockCategoriesControllerImpl.register(any())).called(1);
    });

    testWidgets('Should throw exception when creating category',
        (tester) async {
      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      when(() => mockCategoriesControllerImpl.stateDelete)
          .thenReturn(categoriesDeleteState.idle);

      await tester.pumpWidget(createCategoriesRegisterPage());

      when(() => mockCategoriesControllerImpl.register(any()))
          .thenThrow(Failure());

      final categoryTextField = find.byKey(
        const Key('categories_key_register_categories'),
      );

      final gestureIcon =
          find.byKey(const Key('gesture_icon_key_register_categories_page'));

      final gestureColor =
          find.byKey(const Key('gesture_color_key_register_categories_page'));

      final saveButton = find.byKey(
        const Key('save_button_register_categories_page'),
      );

      final iconsDialog =
          find.byKey(const Key('inkwell_icons_key_0_register_categories_page'));

      final colorsDialog =
          find.byKey(const Key('inkwell_color_key_0_register_categories_page'));

      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);

      await tester.enterText(categoryTextField, 'Test');
      await tester.pumpAndSettle();

      // Inserindo o ícone
      await tester.tap(gestureIcon);
      await tester.pumpAndSettle();

      expect(iconsDialog, findsOneWidget);

      await tester.tap(iconsDialog);
      await tester.pumpAndSettle();

      expect(iconsDialog, findsNothing);

      // Inserindo a cor
      await tester.tap(gestureColor);
      await tester.pumpAndSettle();

      expect(colorsDialog, findsOneWidget);

      await tester.tap(colorsDialog);
      await tester.pumpAndSettle();

      expect(colorsDialog, findsNothing);

      // Salvando registro
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Erro ao criar categoria!'), findsOneWidget);
    });

    testWidgets('Should update category with success', (tester) async {
      isEditing = true;

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      when(() => mockCategoriesControllerImpl.stateDelete)
          .thenReturn(categoriesDeleteState.idle);

      await tester.pumpWidget(createCategoriesRegisterPage());

      when(
        () => mockCategoriesControllerImpl.updateCategory(any(), any()),
      ).thenAnswer((_) async => _);

      final categoryTextField = find.byKey(
        const Key('categories_key_register_categories'),
      );

      final gestureIcon =
          find.byKey(const Key('gesture_icon_key_register_categories_page'));

      final gestureColor =
          find.byKey(const Key('gesture_color_key_register_categories_page'));

      final saveButton = find.byKey(
        const Key('save_button_register_categories_page'),
      );

      final iconsDialog =
          find.byKey(const Key('inkwell_icons_key_0_register_categories_page'));

      final colorsDialog =
          find.byKey(const Key('inkwell_color_key_0_register_categories_page'));

      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);

      await tester.enterText(categoryTextField, 'Test');
      await tester.pumpAndSettle();

      // Inserindo o ícone
      await tester.tap(gestureIcon);
      await tester.pumpAndSettle();

      expect(iconsDialog, findsOneWidget);

      await tester.tap(iconsDialog);
      await tester.pumpAndSettle();

      expect(iconsDialog, findsNothing);

      // Inserindo a cor
      await tester.tap(gestureColor);
      await tester.pumpAndSettle();

      expect(colorsDialog, findsOneWidget);

      await tester.tap(colorsDialog);
      await tester.pumpAndSettle();

      expect(colorsDialog, findsNothing);

      // Salvando registro
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Categoria atualizada com sucesso!'), findsOneWidget);
    });

    testWidgets('Should throw exception when updating category',
        (tester) async {
      isEditing = true;

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      when(() => mockCategoriesControllerImpl.stateDelete)
          .thenReturn(categoriesDeleteState.idle);

      await tester.pumpWidget(createCategoriesRegisterPage());

      when(() => mockCategoriesControllerImpl.updateCategory(any(), any()))
          .thenThrow(Failure());

      final categoryTextField = find.byKey(
        const Key('categories_key_register_categories'),
      );

      final gestureIcon =
          find.byKey(const Key('gesture_icon_key_register_categories_page'));

      final gestureColor =
          find.byKey(const Key('gesture_color_key_register_categories_page'));

      final saveButton = find.byKey(
        const Key('save_button_register_categories_page'),
      );

      final iconsDialog =
          find.byKey(const Key('inkwell_icons_key_0_register_categories_page'));

      final colorsDialog =
          find.byKey(const Key('inkwell_color_key_0_register_categories_page'));

      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);

      await tester.enterText(categoryTextField, 'Test');
      await tester.pumpAndSettle();

      // Inserindo o ícone
      await tester.tap(gestureIcon);
      await tester.pumpAndSettle();

      expect(iconsDialog, findsOneWidget);

      await tester.tap(iconsDialog);
      await tester.pumpAndSettle();

      expect(iconsDialog, findsNothing);

      // Inserindo a cor
      await tester.tap(gestureColor);
      await tester.pumpAndSettle();

      expect(colorsDialog, findsOneWidget);

      await tester.tap(colorsDialog);
      await tester.pumpAndSettle();

      expect(colorsDialog, findsNothing);

      // Salvando registro
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('Erro ao atualizar categoria!'), findsOneWidget);
    });

    testWidgets('Should delete category with success', (tester) async {
      isEditing = true;

      when(() => mockCategoriesControllerImpl.stateDelete)
          .thenReturn(categoriesDeleteState.idle);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      await tester.pumpWidget(createCategoriesRegisterPage());

      when(
        () => mockCategoriesControllerImpl.deleteCategory(
          any(),
        ),
      ).thenAnswer((_) async => _);

      expect(find.byIcon(Icons.delete), findsOneWidget);

      final deleteIcon =
          find.byKey(const Key('icon_delete_key_register_categories_page'));

      final deleteButtonDialog = find.byKey(
        const Key('delete_button_dialog_register_categories_page'),
      );

      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);

      // Deletando registro
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(deleteButtonDialog);
      await tester.pumpAndSettle();

      expect(deleteButtonDialog, findsNothing);
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byWidget(createCategoriesRegisterPage()), findsNothing);
    });

    testWidgets('Should throws when delete category', (tester) async {
      isEditing = true;

      when(() => mockCategoriesControllerImpl.stateDelete)
          .thenReturn(categoriesDeleteState.idle);

      when(() => mockCategoriesControllerImpl.state)
          .thenReturn(categoriesState.idle);

      await tester.pumpWidget(createCategoriesRegisterPage());

      when(
        () => mockCategoriesControllerImpl.deleteCategory(
          any(),
        ),
      ).thenThrow(Failure());

      expect(find.byIcon(Icons.delete), findsOneWidget);

      final deleteIcon =
          find.byKey(const Key('icon_delete_key_register_categories_page'));

      final deleteButtonDialog = find.byKey(
        const Key('delete_button_dialog_register_categories_page'),
      );

      // Deletando registro
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(deleteButtonDialog);
      await tester.pumpAndSettle();

      expect(find.text('Erro ao deletar categoria'), findsOneWidget);
    });
  });
}
