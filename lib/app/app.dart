import 'package:asuka/asuka.dart' as asuka;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/local_storages/flutter_secure_storage_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/logs/log_impl.dart';
import 'package:onde_gastei_app/app/core/navigator/onde_gastei_navigator.dart';
import 'package:onde_gastei_app/app/core/pages/app_page.dart';
import 'package:onde_gastei_app/app/core/rest_client/dio_rest_client.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:onde_gastei_app/app/modules/auth/repositories/auth_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_services_impl.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service_impl.dart';
import 'package:onde_gastei_app/app/modules/splash/splash_page.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );

    return ScreenUtilInit(
      builder: () => MultiProvider(
        providers: [
          Provider(
            create: (context) => SharedPreferencesLocalStorageImpl(),
          ),
          Provider(
            create: (context) => FlutterSecureStorageLocalStorageImpl(),
          ),
          Provider(
            create: (context) => LogImpl(),
          ),
          Provider(
            create: (context) => DioRestClient(
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
              localSecurityStorage:
                  context.read<FlutterSecureStorageLocalStorageImpl>(),
              log: context.read<LogImpl>(),
            ),
          ),
          Provider(
            create: (context) => AuthRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: context.read<LogImpl>(),
            ),
          ),
          Provider(
            create: (context) => AuthServicesImpl(
              repository: context.read<AuthRepositoryImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
              localSecurityStorage:
                  context.read<FlutterSecureStorageLocalStorageImpl>(),
              log: context.read<LogImpl>(),
              firebaseAuth: FirebaseAuth.instance,
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthControllerImpl(
              service: context.read<AuthServicesImpl>(),
              log: context.read<LogImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
            ),
          ),
          Provider(
            create: (context) => HomeRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: context.read<LogImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
            ),
          ),
          Provider(
            create: (context) => HomeServiceImpl(
              repository: context.read<HomeRepositoryImpl>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeControllerImpl(
              service: context.read<HomeServiceImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: UiConfig.title,
          initialRoute: SplashPage.router,
          theme: UiConfig.theme,
          builder: asuka.builder,
          navigatorKey: OndeGasteiNavigator.navigatorKey,
          routes: {
            SplashPage.router: (context) => SplashPage(
                  authController: context.read<AuthControllerImpl>(),
                  homeController: context.read<HomeControllerImpl>(),
                ),
            AppPage.router: (context) => AppPage(
                  homeController: context.read<HomeControllerImpl>(),
                ),
            LoginPage.router: (context) => LoginPage(
                  authController: context.read<AuthControllerImpl>(),
                ),
            RegisterPage.router: (context) => RegisterPage(
                  authController: context.read<AuthControllerImpl>(),
                ),
          },
        ),
      ),
    );
  }
}
