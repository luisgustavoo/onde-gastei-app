import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/core/application_start_config.dart';
import 'package:onde_gastei_app/flavors.dart';

Future<void> buildFlavors(Flavor flavor) async {
  F.appFlavor = flavor;

  await ApplicationStartConfig().configureApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(_flavorBanner(child: const App(), show: flavor != Flavor.prod));
}

Widget _flavorBanner({required Widget child, bool show = true}) {
  if (show) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Banner(
        location: BannerLocation.topEnd,
        message: F.name,
        color: Colors.red,
        textStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
          letterSpacing: 1,
        ),
        textDirection: TextDirection.ltr,
        child: child,
      ),
    );
  }

  return child;
}
