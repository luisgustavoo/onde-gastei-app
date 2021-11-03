import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/theme_extension.dart';

class OndeGasteiButton extends StatelessWidget {
  const OndeGasteiButton(
    Widget child, {
    double width = 300,
    double height = 60,
    double borderRadius = 20,
    Color? color,
    VoidCallback? onPressed,
    Key? key,
  })  : _child = child,
        _height = height,
        _width = width,
        _color = color,
        _borderRadius = borderRadius,
        _onPressed = onPressed,
        super(key: key);

  final Widget _child;
  final double _height;
  final double _width;
  final double _borderRadius;
  final Color? _color;
  final VoidCallback? _onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(
          Size(_width.w, _height.h),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius.r),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return context.primaryColor.withOpacity(0.5);
            }
            return _color ?? context.primaryColor;
          },
        ),
      ),
      onPressed: _onPressed,
      child: _child,
    );
  }
}
