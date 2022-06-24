import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  Environments._();

  static String? param(String paramName) {
    if (kReleaseMode) {
      return FirebaseRemoteConfig.instance.getString(paramName);
    } else {
      return dotenv.env[paramName];
    }
  }

  static Future<void> loadEnvs() async {
    if (kReleaseMode) {
      await FirebaseRemoteConfig.instance.fetchAndActivate();
    } else {
      await dotenv.load();
    }
  }

  static Future<void> getTheme() async {
    if (kReleaseMode) {
      await FirebaseRemoteConfig.instance.fetchAndActivate();
    } else {
      await dotenv.load();
    }
  }
}
