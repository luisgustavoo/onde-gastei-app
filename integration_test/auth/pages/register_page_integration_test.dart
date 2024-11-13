import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:provider/provider.dart';

class MockAuthControllerImpl extends Mock implements AuthControllerImpl {}

void main() {
  late AuthControllerImpl mockAuthControllerImpl;

  Widget createRegisterPage() {
    return ChangeNotifierProvider<AuthControllerImpl>(
      create: (context) => mockAuthControllerImpl,
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          theme: UiConfig.themeLight,
          initialRoute: RegisterPage.router,
          routes: {
            RegisterPage.router: (context) {
              return RegisterPage(
                authController: mockAuthControllerImpl,
              );
            },
          },
        ),
      ),
    );
  }

  setUp(() {
    mockAuthControllerImpl = MockAuthControllerImpl();
  });

  group('Group test register page', () {
    testWidgets('Test if register page shows up', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      await tester.pumpWidget(createRegisterPage());

      //Assert
      expect(find.text('Cadastro'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Como quer ser chamado?'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextFormField, 'E-mail'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Confirmar senha'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Confirmar senha'),
        findsOneWidget,
      );

      expect(
        find.byType(
          ElevatedButton,
        ),
        findsOneWidget,
      );

      expect(find.widgetWithText(ElevatedButton, 'Cadastrar'), findsOneWidget);

      expect(
        find.byType(
          TextFormField,
        ),
        findsNWidgets(4),
      );
    });

    testWidgets('Should TextFormFields is empty', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      when(() => mockAuthControllerImpl.register(any(), any(), any()))
          .thenAnswer((_) async => _);

      await tester.pumpWidget(createRegisterPage());

      final registerButton =
          find.byKey(const ValueKey('register_button_key_register_page'));

      await tester.tap(registerButton);
      await tester.pumpAndSettle();
      await Future<void>.delayed(const Duration(seconds: 1));

      expect(find.text('Email obrigatório'), findsOneWidget);
      expect(find.text('Senha obrigatória'), findsOneWidget);
      expect(find.text('Confirmar senha obrigatório'), findsOneWidget);
    });

    testWidgets('Should E-mail invalid ', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      when(() => mockAuthControllerImpl.register(any(), any(), any()))
          .thenAnswer((_) async => _);

      await tester.pumpWidget(createRegisterPage());

      final name = find.byKey(const ValueKey('name_key_register_page'));

      final email = find.byKey(const ValueKey('email_key_register_page'));

      final password = find.byKey(const ValueKey('password_key_register_page'));

      final confirmPassword =
          find.byKey(const ValueKey('confirm_password_key_register_page'));

      final buttonRegister =
          find.byKey(const ValueKey('register_button_key_register_page'));

      await tester.enterText(name, 'Test');
      await tester.enterText(email, 'test');
      await tester.enterText(password, 'password');
      await tester.enterText(confirmPassword, 'password');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.tap(buttonRegister);
      await tester.pumpAndSettle();

      expect(find.text('E-mail inválido'), findsOneWidget);
    });
  });
}
