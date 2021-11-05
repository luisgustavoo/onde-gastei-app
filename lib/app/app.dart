import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/local_storages/flutter_secure_storage_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/rest_client/dio_rest_client.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/page/login_page.dart';
import 'package:onde_gastei_app/app/modules/auth/page/register_page.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/page/home_page.dart';
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
            create: (_) => SharedPreferencesLocalStorageImpl(),
          ),
          Provider(
            create: (_) => FlutterSecureStorageLocalStorageImpl(),
          ),
          Provider(
            create: (context) => DioRestClient(),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthController(
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeController(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: UiConfig.title,
          initialRoute: '/splash',
          theme: UiConfig.theme,
          routes: {
            SplashPage.router: (context) => SplashPage(
                  authController: context.read<AuthController>(),
                ),
            LoginPage.router: (context) => const LoginPage(),
            HomePage.router: (context) => HomePage(
                  homeController: context.read<HomeController>(),
                ),
            RegisterPage.router: (context) => const RegisterPage(),
          },
        ),
      ),
    );
  }
}
