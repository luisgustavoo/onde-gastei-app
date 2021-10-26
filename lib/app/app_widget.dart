import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/modules/auth/auth_module.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      builder: () => MaterialApp(
        title: UiConfig.title,
        initialRoute: '/auth',
        theme: UiConfig.theme,
        routes: {
          ...AuthModule().routers,
        },
      ),
    );
  }
}
