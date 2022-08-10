import 'package:firebase_performance/firebase_performance.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';

class MockMetricsMonitor extends Mock implements MetricsMonitor {}

class MockTrace extends Mock implements Trace {}
