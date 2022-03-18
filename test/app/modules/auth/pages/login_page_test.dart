import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}

class MockAuthControllerImpl extends Mock implements AuthControllerImpl {}

void main() {
  late NavigatorObserver mockNavigatorObserver;
  late AuthControllerImpl mockAuthControllerImpl;

  Widget createLoginPagePage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthControllerImpl>(
          create: (context) => mockAuthControllerImpl,
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () => MaterialApp(
          initialRoute: LoginPage.router,
          navigatorObservers: [mockNavigatorObserver],
          routes: {
            LoginPage.router: (context) {
              return LoginPage(
                authController: mockAuthControllerImpl,
              );
            },
            AppPage.router: (context) => Container(),
          },
        ),
      ),
    );
  }

  setUp(() {
    mockAuthControllerImpl = MockAuthControllerImpl();
    mockNavigatorObserver = MockNavigatorObserver();
    registerFallbackValue(MockRoute());
  });

  group('Group test login page', () {
    testWidgets('Test if login page shows up', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      await tester.pumpWidget(createLoginPagePage());

      expect(find.byType(Logo), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'E-mail'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
      expect(
        find.widgetWithText(TextButton, 'Esqueceu a senha?'),
        findsOneWidget,
      );
      expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cadastre-se'), findsOneWidget);
    });

    testWidgets('Should TextFormFields is empty', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);
      await tester.pumpWidget(createLoginPagePage());

      final email = find.byKey(const ValueKey('email_key_login_page'));

      final password = find.byKey(const ValueKey('password_key_login_page'));

      final loginButton =
          find.byKey(const ValueKey('button_login_key_login_page'));

      await tester.enterText(email, '');
      await tester.enterText(password, '');
      await tester.pump();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(Logo), findsOneWidget);
      expect(find.text('Email obrigatório'), findsOneWidget);
      expect(find.text('Senha obrigatória'), findsOneWidget);
    });
    testWidgets('Should E-mail invalid', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);
      await tester.pumpWidget(createLoginPagePage());

      final email = find.byKey(const ValueKey('email_key_login_page'));

      final password = find.byKey(const ValueKey('password_key_login_page'));

      final loginButton =
          find.byKey(const ValueKey('button_login_key_login_page'));

      await tester.enterText(email, 'test');
      await tester.enterText(password, '');
      await tester.pump();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(Logo), findsOneWidget);
      expect(find.text('E-mail inválido'), findsOneWidget);
      expect(find.text('Senha obrigatória'), findsOneWidget);
    });

    testWidgets('Should password must be at least 6 characters long',
        (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      await tester.pumpWidget(createLoginPagePage());

      final email = find.byKey(const ValueKey('email_key_login_page'));

      final password = find.byKey(const ValueKey('password_key_login_page'));

      final loginButton =
          find.byKey(const ValueKey('button_login_key_login_page'));

      await tester.enterText(email, 'test@teste.com');
      await tester.enterText(password, '123');
      await tester.pump();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(Logo), findsOneWidget);
      expect(
        find.text('A senha tem que ter no mínimo 6 caracteres'),
        findsOneWidget,
      );
    });

    testWidgets('Should login with success', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      when(() => mockAuthControllerImpl.login(any(), any()))
          .thenAnswer((_) async => _);

      when(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).thenAnswer((_) async => _);

      await tester.pumpWidget(createLoginPagePage());

      final email = find.byKey(const ValueKey('email_key_login_page'));

      final password = find.byKey(const ValueKey('password_key_login_page'));

      final loginButton =
          find.byKey(const ValueKey('button_login_key_login_page'));

      await tester.enterText(email, 'test@test.com');
      await tester.enterText(password, '123456');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      verify(() => mockAuthControllerImpl.login(any(), any())).called(1);
      verify(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).called(1);
    });

    testWidgets('Should trows UserNotFoundException', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      when(() => mockAuthControllerImpl.login(any(), any()))
          .thenThrow(UserNotFoundException());

      await tester.pumpWidget(createLoginPagePage());

      final email = find.byKey(const ValueKey('email_key_login_page'));

      final password = find.byKey(const ValueKey('password_key_login_page'));

      final loginButton =
          find.byKey(const ValueKey('button_login_key_login_page'));

      await tester.enterText(email, 'test@teste.com');
      await tester.enterText(password, '123456');
      await tester.pump();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Login e senha inválidos!', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('Should trows UnverifiedEmailException', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      when(() => mockAuthControllerImpl.login(any(), any()))
          .thenThrow(UnverifiedEmailException());

      await tester.pumpWidget(createLoginPagePage());

      final email = find.byKey(const ValueKey('email_key_login_page'));

      final password = find.byKey(const ValueKey('password_key_login_page'));

      final loginButton =
          find.byKey(const ValueKey('button_login_key_login_page'));

      await tester.enterText(email, 'test@teste.com');
      await tester.enterText(password, '123456');
      await tester.pump();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(
          'E-mail não verificado!\n\nAcesse o seu e-mail para fazer a verificação',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('Should trows generic Exception', (tester) async {
      when(() => mockAuthControllerImpl.state).thenReturn(AuthState.idle);

      when(() => mockAuthControllerImpl.login(any(), any()))
          .thenThrow(Exception());

      await tester.pumpWidget(createLoginPagePage());

      final email = find.byKey(const ValueKey('email_key_login_page'));

      final password = find.byKey(const ValueKey('password_key_login_page'));

      final loginButton =
          find.byKey(const ValueKey('button_login_key_login_page'));

      await tester.enterText(email, 'test@teste.com');
      await tester.enterText(password, '123456');
      await tester.pump();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(
          'Erro ao realizar login tente novamente mais tarde!!!',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });
  });
}
