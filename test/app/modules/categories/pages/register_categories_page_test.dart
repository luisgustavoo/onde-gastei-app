import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/register_categories_page.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service.dart';
import 'package:provider/provider.dart';

import '../../../../core/log/mock_log.dart';
import '../controllers/categories_controller_impl_test.dart';

late CategoriesControllerImpl controller;
late CategoriesService service;
late Log log;

class MockCategoriesControllerImpl extends Mock
    implements CategoriesControllerImpl {}

Widget createRegisterCategoriesPage() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => controller,
      ),
    ],
    child: ScreenUtilInit(
      builder: () => MaterialApp(
        initialRoute: RegisterCategoriesPage.router,
        routes: {
          RegisterCategoriesPage.router: (context) =>
              const RegisterCategoriesPage(
                  // categoriesController: controller,
                  )
        },
      ),
    ),
  );
}

void main() {
  setUp(() {
    service = MockCategoriesServices();
    log = MockLog();
    controller = MockCategoriesControllerImpl();
  });

  group('Group test RegisterCategoriesPage ', () {
    testWidgets('Test if register categories page shows up', (tester) async {
      await tester.pumpWidget(createRegisterCategoriesPage());

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
      expect(
        find.widgetWithIcon(
          IconButton,
          Icons.close,
        ),
        findsOneWidget,
      );

      expect(buildIcon, findsOneWidget);
      expect(buildColor, findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);
    });

    testWidgets('Should TextFormField is empty', (tester) async {
      await tester.pumpWidget(createRegisterCategoriesPage());

      final categoryTextField = find.byKey(
        const Key('categories_key_register_categories'),
      );

      final saveButton = find.byKey(
        const Key('button_save_register_categories_page'),
      );

      expect(find.widgetWithText(ElevatedButton, 'Salvar'), findsOneWidget);

      await tester.enterText(categoryTextField, '');
      await tester.pump();

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(find.text('A categoria é obrigatório'), findsOneWidget);
    });

    testWidgets('Should create category with success', (tester) async {
      const categoryModel = CategoryModel(
        description: 'Test',
        iconCode: 1,
        colorCode: 1,
        userId: 1,
      );

      await tester.pumpWidget(createRegisterCategoriesPage());
      when(() => controller.register(categoryModel)).thenAnswer((_) async => _);
      when(() => controller.state).thenReturn(categoriesState.idle);

      final categoryTextField = find.byKey(
        const Key('categories_key_register_categories'),
      );

      final gestureIcon =
          find.byKey(const Key('gesture_icon_key_register_categories_page'));

      final gestureColor =
          find.byKey(const Key('gesture_color_key_register_categories_page'));

      final saveButton = find.byKey(
        const Key('button_save_register_categories_page'),
      );

      final iconsDialog =
          find.byKey(const Key('inkwell_icons_key_register_categories_page_0'));

      final colorsDialog =
          find.byKey(const Key('inkwell_color_key_register_categories_page_0'));

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

      // expect(find.text('Categoria criada com sucesso!'), findsOneWidget);
    });
  });
}
