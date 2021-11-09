import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter/material.dart';

class Loader {
  Loader._();

  static OverlayEntry? _entry;
  static bool _open = false;

  static void show() {
    _entry ??= OverlayEntry(
      builder: (context) {
        return Container(
          color: Colors.black54,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );

    if (!_open) {
      _open = true;
      asuka.addOverlay(_entry!);
    }
  }

  static void hide() {
    if (_open) {
      _open = false;
      _entry?.remove();
    }
  }
}
