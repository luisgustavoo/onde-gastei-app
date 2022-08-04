import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/helpers/environments.dart';

class ApplicationStartConfig {
  Future<void> configureApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await _firebaseConfig();
    await _loadEnvs();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  Future<void> _firebaseConfig() async => Firebase.initializeApp();

  Future<void> _loadEnvs() async => Environments.loadEnvs();
}
