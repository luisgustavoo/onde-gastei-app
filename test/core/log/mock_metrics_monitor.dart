import 'package:firebase_performance/firebase_performance.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';

class MockMetricsMonitor extends Mock implements MetricsMonitor {
  void checkCalledMetrics(Trace trace) {
    verify(() => addTrace(any())).called(1);
    verify(() => startTrace(trace)).called(1);
    verify(() => stopTrace(trace)).called(1);
  }

  void mockCalledMetrics(Trace trace) {
    when(() => addTrace(any())).thenAnswer((_) => trace);
    when(() => startTrace(trace)).thenAnswer((_) async => _);
    when(() => stopTrace(trace)).thenAnswer((_) async => _);
  }
}

class MockTrace extends Mock implements Trace {}
