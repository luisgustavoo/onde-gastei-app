import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';

class FirebaseCrashlyticsImpl implements Log {
  List<String> messages = <String>[];
  final instance = FirebaseCrashlytics.instance;

  @override
  void append(String message) {
    messages.add(message);
  }

  @override
  void closeAppend() {
    instance.log(messages.join('\n'));
    messages.clear();
  }

  @override
  void debug(Object message, [Object? error, StackTrace? stackTrace]) {
    instance.log(message.toString());
  }

  @override
  void error(Object message, [Object? error, StackTrace? stackTrace]) {
    instance.recordError(error, stackTrace, fatal: true, reason: message);
  }

  @override
  void info(Object message, [Object? error, StackTrace? stackTrace]) {
    instance.log(message.toString());
  }

  @override
  void warning(Object message, [Object? error, StackTrace? stackTrace]) {
    instance.log(message.toString());
  }
}
