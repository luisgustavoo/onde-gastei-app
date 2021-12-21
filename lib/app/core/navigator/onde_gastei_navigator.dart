import 'package:flutter/cupertino.dart';

class OndeGasteiNavigator {
  OndeGasteiNavigator._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get to => navigatorKey.currentState;
}
