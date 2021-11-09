abstract class Log {
  void debug(Object message, [Object? error, StackTrace? stackTrace]);

  void error(Object message, [Object? error, StackTrace? stackTrace]);

  void warning(Object message, [Object? error, StackTrace? stackTrace]);

  void info(Object message, [Object? error, StackTrace? stackTrace]);

  void append(String message);

  void closeAppend();
}
