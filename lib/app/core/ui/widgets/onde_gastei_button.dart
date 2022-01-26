import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/theme_extension.dart';

class OndeGasteiButton extends StatelessWidget {
  OndeGasteiButton(
    Widget child, {
    double width = 300,
    double height = 60,
    double borderRadius = 20,
    Color? color,
    VoidCallback? onPressed,
    bool isLoading = false,
    Key? key,
  })  : _child = child,
        _height = height,
        _width = width,
        _color = color,
        _borderRadius = borderRadius,
        _onPressed = onPressed,
        _isLoading = ValueNotifier<bool>(isLoading),
        super(key: key);

  final Widget _child;
  final double _height;
  final double _width;
  final double _borderRadius;
  final Color? _color;
  final VoidCallback? _onPressed;
  final ValueNotifier<bool> _isLoading;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, value, _) {
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
          onPressed: value ? null : _onPressed,
          child: value
              ? SizedBox(
                  height: 25.h,
                  width: 25.w,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1.w,
                  ),
                )
              : _child,
        );
      },
    );
  }
}
