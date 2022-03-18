import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/splash/controllers/splash_controller.dart';
import 'package:onde_gastei_app/app/modules/splash/pages/splash_page.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

late SplashController mockSplashController;
late NavigatorObserver mockNavigatorObserver;

class MockSplashController extends Mock implements SplashController {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

Widget createSplashPage() {
  return MultiProvider(
    providers: [
      Provider<SplashController>(
        create: (context) => mockSplashController,
      ),
    ],
    child: ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
        ],
        initialRoute: SplashPage.router,
        routes: {
          SplashPage.router: (context) =>
              SplashPage(splashController: mockSplashController),
          AppPage.router: (context) => const Scaffold(body: Text('App Page')),
          LoginPage.router: (context) =>
              const Scaffold(body: Text('Login Page')),
        },
      ),
    ),
  );
}

void main() {
  setUp(() {
    mockSplashController = MockSplashController();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  group('Group test splash page', () {
    testWidgets('Test if login page shows up', (tester) async {
      final userExpected = UserModel(
        userId: 1,
        name: 'Test',
        email: 'test@domain.com',
      );
      when(() => mockSplashController.getUser())
          .thenAnswer((_) async => userExpected);

      when(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).thenAnswer((_) async => _);

      await tester.pumpWidget(createSplashPage());

      verify(() => mockSplashController.getUser()).called(1);

      verify(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).called(1);

      final appPageFinder = find.byType(Scaffold);
      final messageFinder = find.text('App Page');
      find.ancestor(of: appPageFinder, matching: messageFinder);
    });

    testWidgets('Test if splash page navigate to LoginPage', (tester) async {
      when(() => mockSplashController.getUser()).thenAnswer((_) async => null);

      when(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).thenAnswer((_) async => _);

      await tester.pumpWidget(createSplashPage());

      verify(() => mockSplashController.getUser()).called(1);

      verify(
        () => mockNavigatorObserver.didReplace(
          oldRoute: any(named: 'oldRoute'),
          newRoute: any(named: 'newRoute'),
        ),
      ).called(1);

      final appPageFinder = find.byType(Scaffold);
      final messageFinder = find.text('Login Page');
      find.ancestor(of: appPageFinder, matching: messageFinder);
    });
  });
}
