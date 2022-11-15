import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/core/application_start_config.dart';

Future<void> main() async {
  await ApplicationStartConfig().configureApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const App());

  // await runZonedGuarded<Future<void>>(
  //   () async {
  //     await ApplicationStartConfig().configureApp();
  //     runApp(const App());
  //   },
  //   (error, stack) =>
  //       FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  // );
}
