import 'package:firebase_performance/firebase_performance.dart';

abstract class MetricsMonitor {
  Trace addTrace(String name);

  void incrementTrace(Trace trace, String name, int value);

  Future<void> startTrace(Trace trace);

  Future<void> stopTrace(Trace trace);
}
