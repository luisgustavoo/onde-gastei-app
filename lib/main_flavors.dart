import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/app.dart';

import 'package:onde_gastei_app/app/core/application_start_config.dart';
import 'package:onde_gastei_app/flavors.dart';

Future<void> buidFlavors(Flavor flavor) async {
  F.appFlavor = flavor;

  await ApplicationStartConfig().configureApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const App());
}
