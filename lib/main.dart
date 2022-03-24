import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/core/application_start_config.dart';

Future<void> main() async {
  await ApplicationStartConfig().configureApp();
  runApp(const App());
}
