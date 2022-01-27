import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../../../../core/local_storage/mock_local_storage.dart';
import '../../../../core/log/mock_log.dart';
import '../controllers/auth_controller_impl_test.dart';

late AuthService mockService;
late Log mockLog;
late LocalStorage mockLocalStorage;

Widget createRegisterPage() {
  return ChangeNotifierProvider<AuthControllerImpl>(
    create: (context) => AuthControllerImpl(
      localStorage: mockLocalStorage,
      log: mockLog,
      service: mockService,
    ),
    child: ScreenUtilInit(
      builder: () => MaterialApp(
        initialRoute: RegisterPage.router,
        routes: {
          RegisterPage.router: (context) {
            return const RegisterPage();
          }
        },
      ),
    ),
  );
}

void main() {
  setUp(() {
    mockService = MockAuthService();
    mockLog = MockLog();
    mockLocalStorage = MockLocalStorage();
  });

  group('Group test register page', () {
    testWidgets('Test if register page shows up', (tester) async {
      //Arrange

      //Act
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
      //Arrange
      when(() => mockService.register(any(), any(), any()))
          .thenAnswer((_) async => _);

      await tester.pumpWidget(createRegisterPage());

      final name = find.byKey(const ValueKey('name_key_register_page'));

      final email = find.byKey(const ValueKey('email_key_register_page'));

      final password = find.byKey(const ValueKey('password_key_register_page'));

      final confirmPassword =
          find.byKey(const ValueKey('confirm_password_key_register_page'));

      final registerButton =
          find.byKey(const ValueKey('register_button_key_register_page'));

      await tester.enterText(name, '');
      await tester.enterText(email, '');
      await tester.enterText(password, '');
      await tester.enterText(confirmPassword, '');

      //Act
      await tester.pump();

      //Act
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      //Assert
      expect(find.text('Email obrigatório'), findsOneWidget);
      expect(find.text('Senha obrigatória'), findsOneWidget);
      expect(find.text('Confirmar senha obrigatório'), findsOneWidget);
    });

    testWidgets('Should E-mail invalid ', (tester) async {
      //Arrange
      when(() => mockService.register(any(), any(), any()))
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

      //Act
      await tester.pump();

      //Act
      await tester.tap(buttonRegister);
      await tester.pumpAndSettle();

      //Assert
      expect(find.text('E-mail inválido'), findsOneWidget);
    });

    testWidgets('Should password must be at least 6 characters long',
        (tester) async {
      //Arrange
      when(() => mockService.register(any(), any(), any()))
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
      await tester.enterText(email, 'test@test.com');
      await tester.enterText(password, '123');
      await tester.enterText(confirmPassword, '123');

      //Act
      await tester.pump();

      //Act
      await tester.tap(buttonRegister);
      await tester.pumpAndSettle();

      //Assert
      expect(
        find.text('A senha tem que ter no mínimo 6 caracteres'),
        findsOneWidget,
      );
    });

    testWidgets('Should password and confirm password are not the same',
        (tester) async {
      //Arrange
      when(() => mockService.register(any(), any(), any()))
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
      await tester.enterText(email, 'test@test.com');
      await tester.enterText(password, '123');
      await tester.enterText(confirmPassword, '1234');

      //Act
      await tester.pump();

      //Act
      await tester.tap(buttonRegister);
      await tester.pumpAndSettle();

      //Assert
      expect(
        find.text('Senha e confirmar senha não são iguais'),
        findsOneWidget,
      );
    });

    testWidgets('Should register user with success', (tester) async {
      //Arrange
      when(() => mockService.register(any(), any(), any()))
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
      await tester.enterText(email, 'test@test.com');
      await tester.enterText(password, 'password');
      await tester.enterText(confirmPassword, 'password');

      //Act
      await tester.pump();

      //Assert
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('test@test.com'), findsOneWidget);
      expect(find.text('password'), findsNWidgets(2));

      //Act
      await tester.tap(buttonRegister);
      await tester.pumpAndSettle();

      //Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(
          'Usuário registrado com sucesso!\n\nVerifique o e-mail cadastrado para concluir o processo',
          findRichText: true,
        ),
        findsOneWidget,
      );

      await tester.pumpAndSettle();

      //Assert
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
    });

    testWidgets('Should trows UserExistsException', (tester) async {
      //Arrange
      when(() => mockService.register(any(), any(), any()))
          .thenThrow(UserExistsException());

      await tester.pumpWidget(createRegisterPage());

      final name = find.byKey(const ValueKey('name_key_register_page'));

      final email = find.byKey(const ValueKey('email_key_register_page'));

      final password = find.byKey(const ValueKey('password_key_register_page'));

      final confirmPassword =
          find.byKey(const ValueKey('confirm_password_key_register_page'));

      final buttonRegister =
          find.byKey(const ValueKey('register_button_key_register_page'));

      await tester.enterText(name, 'Test');
      await tester.enterText(email, 'test@test.com');
      await tester.enterText(password, 'password');
      await tester.enterText(confirmPassword, 'password');

      //Act
      await tester.pump();

      //Assert
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('test@test.com'), findsOneWidget);
      expect(find.text('password'), findsNWidgets(2));

      //Act
      await tester.tap(buttonRegister);
      await tester.pumpAndSettle();

      //Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(
          'Email já cadastrado, por favor escolha outro e-mail',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Should trows generic Exception', (tester) async {
      //Arrange
      when(() => mockService.register(any(), any(), any()))
          .thenThrow(Exception());

      await tester.pumpWidget(createRegisterPage());

      final name = find.byKey(const ValueKey('name_key_register_page'));

      final email = find.byKey(const ValueKey('email_key_register_page'));

      final password = find.byKey(const ValueKey('password_key_register_page'));

      final confirmPassword =
          find.byKey(const ValueKey('confirm_password_key_register_page'));

      final buttonRegister =
          find.byKey(const ValueKey('register_button_key_register_page'));

      await tester.enterText(name, 'Test');
      await tester.enterText(email, 'test@test.com');
      await tester.enterText(password, 'password');
      await tester.enterText(confirmPassword, 'password');

      //Act
      await tester.pump();

      //Assert
      expect(find.text('Test'), findsOneWidget);
      expect(find.text('test@test.com'), findsOneWidget);
      expect(find.text('password'), findsNWidgets(2));

      //Act
      await tester.tap(buttonRegister);
      await tester.pumpAndSettle();

      //Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Erro ao registrar usuário', findRichText: true),
        findsOneWidget,
      );
    });
  });
}
