import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/modules/users/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/users/auth/page/auth_page.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        title: UiConfig.title,
        initialRoute: '/auth',
        theme: UiConfig.theme,
        routes: {
          AuthPage.router: (context) {
            return ChangeNotifierProvider(
              create: (context) => AuthController(),
              builder: (context, _) => AuthPage(
                authController: context.read<AuthController>(),
              ),
            );
          },
        },
      ),
    );
  }
}
