import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/user/pages/user_page.dart';
import 'package:provider/provider.dart';

class MockUserControllerImpl extends Mock implements UserControllerImpl {}

void main() {
  late UserControllerImpl mockUserControllerImpl;

  setUp(() {
    mockUserControllerImpl = MockUserControllerImpl();
  });

  Widget createUserPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserControllerImpl>(
          create: (context) => mockUserControllerImpl,
        )
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
            ],
            initialRoute: UserPage.router,
            routes: {
              UserPage.router: (context) => UserPage(
                    userController: mockUserControllerImpl,
                  ),
            },
          );
        },
      ),
    );
  }

  group('Group test user page', () {
    testWidgets('Test if user page shows up', (tester) async {
      when(() => mockUserControllerImpl.user).thenReturn(
        const UserModel(userId: 1, name: 'Test', firebaseUserId: '123456'),
      );

      when(() => mockUserControllerImpl.state).thenReturn(UserState.idle);

      await tester.pumpWidget(createUserPage());

      expect(find.widgetWithText(OndeGasteiTextForm, 'Test'), findsOneWidget);
      expect(find.widgetWithText(OndeGasteiButton, 'Salvar'), findsOneWidget);
    });

    testWidgets('Test user name change', (tester) async {
      when(() => mockUserControllerImpl.user).thenReturn(
        const UserModel(userId: 1, name: 'Test', firebaseUserId: '123456'),
      );

      when(() => mockUserControllerImpl.state).thenReturn(UserState.idle);
      when(
        () => mockUserControllerImpl.updateUserName(
          any(),
          any(),
        ),
      ).thenAnswer((_) async => _);

      final saveButton = find.byType(OndeGasteiButton);

      await tester.pumpWidget(createUserPage());

      await tester.enterText(
        find.widgetWithText(OndeGasteiTextForm, 'Test'),
        'Test 2',
      );

      expect(find.widgetWithText(OndeGasteiTextForm, 'Test 2'), findsOneWidget);
      expect(find.widgetWithText(OndeGasteiButton, 'Salvar'), findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(SnackBar, 'Nome atualizado com sucesso!'),
        findsOneWidget,
      );
    });

    testWidgets('Test error in changing user name', (tester) async {
      when(() => mockUserControllerImpl.user).thenReturn(
        const UserModel(userId: 1, name: 'Test', firebaseUserId: '123456'),
      );

      when(() => mockUserControllerImpl.state).thenReturn(UserState.idle);
      when(
        () => mockUserControllerImpl.updateUserName(
          any(),
          any(),
        ),
      ).thenThrow(Exception());

      final saveButton = find.byType(OndeGasteiButton);

      await tester.pumpWidget(createUserPage());

      await tester.enterText(
        find.widgetWithText(OndeGasteiTextForm, 'Test'),
        'Test 2',
      );

      expect(find.widgetWithText(OndeGasteiTextForm, 'Test 2'), findsOneWidget);
      expect(find.widgetWithText(OndeGasteiButton, 'Salvar'), findsOneWidget);

      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(SnackBar, 'Erro ao atualizar nome'),
        findsOneWidget,
      );
    });
  });
}
