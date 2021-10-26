import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class OndeGasteiPage extends StatelessWidget {
  const OndeGasteiPage(
      {required WidgetBuilder page,
      List<SingleChildWidget>? bindings,
      Key? key})
      : _page = page,
        _bindings = bindings,
        super(key: key);

  final List<SingleChildWidget>? _bindings;
  final WidgetBuilder _page;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _bindings ?? [Provider(create: (context) => Object())],
      child: Builder(
        builder: _page,
      ),
    );
  }
}
