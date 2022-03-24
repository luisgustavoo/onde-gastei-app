import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/helpers/environments.dart';

class ApplicationStartConfig {
  Future<void> configureApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _firebaseConfig();
    await _loadEnvs();
  }

  Future<void> _firebaseConfig() async => Firebase.initializeApp();

  Future<void> _loadEnvs() async => Environments.loadEnvs();
}
