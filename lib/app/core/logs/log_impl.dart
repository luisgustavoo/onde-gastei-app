import 'package:logger/logger.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';

class LogImpl implements Log {
  List<String> messages = <String>[];
  final log = Logger();

  @override
  void append(String message) {
    messages.add(message);
  }

  @override
  void closeAppend() {
    info(messages.join('\n'));
    messages.clear();
  }

  @override
  void debug(Object message, [Object? error, StackTrace? stackTrace]) {
    log.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void error(Object message, [Object? error, StackTrace? stackTrace]) {
    log.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(Object message, [Object? error, StackTrace? stackTrace]) {
    log.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(Object message, [Object? error, StackTrace? stackTrace]) {
    log.w(message, error: error, stackTrace: stackTrace);
  }
}
