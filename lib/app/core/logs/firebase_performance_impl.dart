import 'package:firebase_performance/firebase_performance.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';

class FirebasePerformanceImpl implements MetricsMonitor {
  final _instance = FirebasePerformance.instance;

  @override
  Trace addTrace(String name) => _instance.newTrace(name);

  @override
  void incrementTrace(Trace trace, String name, int value) =>
      trace.incrementMetric(name, value);

  @override
  Future<void> startTrace(Trace trace) => trace.start();

  @override
  Future<void> stopTrace(Trace trace) => trace.stop();
}
