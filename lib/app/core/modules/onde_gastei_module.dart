import 'package:flutter/cupertino.dart';
import 'package:onde_gastei_app/app/core/modules/onde_gastei_page.dart';
import 'package:provider/single_child_widget.dart';

abstract class OndeGasteiModule {
  OndeGasteiModule(
      {required Map<String, WidgetBuilder> routers,
      List<SingleChildWidget>? bindings})
      : _routers = routers,
        _bindings = bindings;

  final Map<String, WidgetBuilder> _routers;
  final List<SingleChildWidget>? _bindings;

  Map<String, WidgetBuilder> get routers {
    return _routers.map(
      (key, pageBuilder) => MapEntry(
        key,
        (_) => OndeGasteiPage(
          bindings: _bindings,
          page: pageBuilder,
        ),
      ),
    );
  }
}
