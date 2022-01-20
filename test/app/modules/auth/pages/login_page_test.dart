import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_service.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

import '../../../../core/local_storage/mock_local_storage.dart';
import '../../../../core/log/mock_log.dart';
import '../controllers/auth_controller_impl_test.dart';

late AuthService mockAuthService;
late NavigatorObserver mockNavigatorObserver;
late Log mockLog;
late LocalStorage mockLocalStorage;
late HomeService mockHomeService;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockHomeService extends Mock implements HomeService {}

class MockRoute extends Mock implements Route<dynamic> {}

Widget createLoginPagePage() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthControllerImpl(
          localStorage: mockLocalStorage,
          log: mockLog,
          service: mockAuthService,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => HomeControllerImpl(
            localStorage: mockLocalStorage, service: mockHomeService),
      )
    ],
    child: ScreenUtilInit(
      builder: () => MaterialApp(
        initialRoute: LoginPage.router,
        navigatorObservers: [mockNavigatorObserver],
        routes: {
          LoginPage.router: (context) => LoginPage(
                authController: context.read<AuthControllerImpl>(),
              ),
          AppPage.router: (context) => Container()
          // AppPage(homeController: context.read<HomeControllerImpl>()),
        },
      ),
    ),
  );
}

void main() {
  setUp(() {
    mockAuthService = MockAuthService();
    mockLog = MockLog();
    mockLocalStorage = MockLocalStorage();
    mockHomeService = MockHomeService();
    mockNavigatorObserver = MockNavigatorObserver();
    registerFallbackValue(MockRoute());
  });

  group('Group test login pate', () {
    testWidgets('Test if login page shows up', (tester) async {
      //Arrange

      //Act
      await tester.pumpWidget(createLoginPagePage());

      //Assert
      expect(find.byType(Logo), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'E-mail'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
      expect(
          find.widgetWithText(TextButton, 'Esqueceu a senha?'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Entrar'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Cadastre-se'), findsOneWidget);
    });
  });

  testWidgets('Should TextFormFields is empty', (tester) async {
    //Arrange

    await tester.pumpWidget(createLoginPagePage());

    final email = find.byKey(const ValueKey('email_key_login_page'));

    final password = find.byKey(const ValueKey('password_key_login_page'));

    final loginButton =
        find.byKey(const ValueKey('button_login_key_login_page'));

    await tester.enterText(email, '');
    await tester.enterText(password, '');
    await tester.pump();

    //Act
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //Assert
    expect(find.byType(Logo), findsOneWidget);
    expect(find.text('Email obrigatório'), findsOneWidget);
    expect(find.text('Senha obrigatória'), findsOneWidget);
  });

  testWidgets('Should E-mail invalid', (tester) async {
    //Arrange

    await tester.pumpWidget(createLoginPagePage());

    final email = find.byKey(const ValueKey('email_key_login_page'));

    final password = find.byKey(const ValueKey('password_key_login_page'));

    final loginButton =
        find.byKey(const ValueKey('button_login_key_login_page'));

    await tester.enterText(email, 'test');
    await tester.enterText(password, '');
    await tester.pump();

    //Act
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //Assert
    expect(find.byType(Logo), findsOneWidget);
    expect(find.text('E-mail inválido'), findsOneWidget);
    expect(find.text('Senha obrigatória'), findsOneWidget);
  });

  testWidgets('Should password must be at least 6 characters long',
      (tester) async {
    //Arrange

    await tester.pumpWidget(createLoginPagePage());

    final email = find.byKey(const ValueKey('email_key_login_page'));

    final password = find.byKey(const ValueKey('password_key_login_page'));

    final loginButton =
        find.byKey(const ValueKey('button_login_key_login_page'));

    await tester.enterText(email, 'test@teste.com');
    await tester.enterText(password, '123');
    await tester.pump();

    //Act
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //Assert
    expect(find.byType(Logo), findsOneWidget);
    expect(find.text('A senha tem que ter no mínimo 6 caracteres'),
        findsOneWidget);
  });

  testWidgets('Should login with success', (tester) async {
    //Arrange

    when(() => mockAuthService.login(any(), any())).thenAnswer((_) async => _);
    when(() => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        )).thenAnswer((_) async => _);

    // when(() => mockNavigatorObserver.didPush(any(), any()))
    //     .thenAnswer((_) async => _);

    await tester.pumpWidget(createLoginPagePage());

    final email = find.byKey(const ValueKey('email_key_login_page'));

    final password = find.byKey(const ValueKey('password_key_login_page'));

    final loginButton =
        find.byKey(const ValueKey('button_login_key_login_page'));

    await tester.enterText(email, 'test@teste.com');
    await tester.enterText(password, '123456');
    await tester.pumpAndSettle();

    //Act
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //Assert
    verify(() => mockAuthService.login(any(), any())).called(1);
    verify(() => mockNavigatorObserver.didReplace(
        oldRoute: any(named: 'oldRoute'),
        newRoute: any(named: 'newRoute'))).called(1);
  });

  testWidgets('Should trows UserNotFoundException', (tester) async {
    //Arrange
    when(() => mockAuthService.login(any(), any()))
        .thenThrow(UserNotFoundException());

    await tester.pumpWidget(createLoginPagePage());

    final email = find.byKey(const ValueKey('email_key_login_page'));

    final password = find.byKey(const ValueKey('password_key_login_page'));

    final loginButton =
        find.byKey(const ValueKey('button_login_key_login_page'));

    await tester.enterText(email, 'test@teste.com');
    await tester.enterText(password, '123456');
    await tester.pump();

    //Act
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Login e senha inválidos!', findRichText: true),
        findsOneWidget);
  });

  testWidgets('Should trows UnverifiedEmailException', (tester) async {
    //Arrange
    when(() => mockAuthService.login(any(), any()))
        .thenThrow(UnverifiedEmailException());

    await tester.pumpWidget(createLoginPagePage());

    final email = find.byKey(const ValueKey('email_key_login_page'));

    final password = find.byKey(const ValueKey('password_key_login_page'));

    final loginButton =
        find.byKey(const ValueKey('button_login_key_login_page'));

    await tester.enterText(email, 'test@teste.com');
    await tester.enterText(password, '123456');
    await tester.pump();

    //Act
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
        find.text(
            'E-mail não verificado!\n\nAcesse o seu e-mail para fazer a verificação',
            findRichText: true),
        findsOneWidget);
  });

  testWidgets('Should trows generic Exception', (tester) async {
    //Arrange
    when(() => mockAuthService.login(any(), any())).thenThrow(Exception());

    await tester.pumpWidget(createLoginPagePage());

    final email = find.byKey(const ValueKey('email_key_login_page'));

    final password = find.byKey(const ValueKey('password_key_login_page'));

    final loginButton =
        find.byKey(const ValueKey('button_login_key_login_page'));

    await tester.enterText(email, 'test@teste.com');
    await tester.enterText(password, '123456');
    await tester.pump();

    //Act
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    //Assert
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
        find.text('Erro ao realizar login tente novamente mais tarde!!!',
            findRichText: true),
        findsOneWidget);
  });
}
