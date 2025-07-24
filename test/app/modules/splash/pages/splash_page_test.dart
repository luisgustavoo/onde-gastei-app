import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/splash/pages/splash_page.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

late NavigatorObserver mockNavigatorObserver;
late UserControllerImpl mockUserControllerImpl;

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockUserControllerImpl extends Mock implements UserControllerImpl {}

Widget createSplashPage() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<UserControllerImpl>(
        create: (context) => mockUserControllerImpl,
      ),
    ],
    child: ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        initialRoute: SplashPage.router,
        routes: {
          SplashPage.router: (context) =>
              SplashPage(userController: mockUserControllerImpl),
          AppPage.router: (context) {
            return const Scaffold(body: Text('App Page'));
          },
          LoginPage.router: (context) {
            return const Scaffold(body: Text('Login Page'));
          },
        },
      ),
    ),
  );
}

void main() {
  setUp(() {
    mockUserControllerImpl = MockUserControllerImpl();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  group('Group test splash page', () {
    testWidgets('Test if app page shows up', (tester) async {
      when(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).thenAnswer((invocation) async => invocation);

      when(() => mockUserControllerImpl.getLocalUser()).thenAnswer(
        (invocation) async => const UserModel(
          userId: 1,
          name: 'Test',
          email: 'test@domain.com',
          firebaseUserId: '123456',
        ),
      );

      await tester.pumpWidget(createSplashPage());

      verify(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).called(1);

      // final appPageFinder = find.byType(Scaffold);

      // final messageFinder = find.text('App Page');
      await tester.pumpAndSettle();
      expect(find.text('App Page'), findsOneWidget);
    });

    testWidgets('Test if splash page navigate to LoginPage', (tester) async {
      when(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).thenAnswer((invocation) async => invocation);

      when(
        () => mockUserControllerImpl.getLocalUser(),
      ).thenAnswer((_) async => null);

      await tester.pumpWidget(createSplashPage());

      verify(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).called(1);

      final appPageFinder = find.byType(Scaffold);
      final messageFinder = find.text('Login Page');
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: appPageFinder, matching: messageFinder),
        findsOneWidget,
      );
    });
  });
}
