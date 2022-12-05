import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/theme_extension.dart';

class OndeGasteiButton extends StatelessWidget {
  OndeGasteiButton(
    Widget child, {
    double height = 60,
    double? width = 300,
    double borderRadius = 20,
    Color? color,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool disable = false,
    super.key,
  })  : _child = child,
        _height = height,
        _width = width,
        _color = color,
        _borderRadius = borderRadius,
        _onPressed = onPressed,
        _disable = disable,
        _isLoading = ValueNotifier<bool>(isLoading);

  final Widget _child;
  final double _height;
  final double? _width;
  final double _borderRadius;
  final Color? _color;
  final VoidCallback? _onPressed;
  final ValueNotifier<bool> _isLoading;
  final bool _disable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, _) {
        return ElevatedButton(
          style: ButtonStyle(
            fixedSize: MaterialStateProperty.all<Size>(
              Size(_width!.w, _height.h),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_borderRadius.r),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (_disable) {
                  return Constants.buttonColorDisabled;
                }

                if (states.contains(MaterialState.pressed)) {
                  return _color != null
                      ? _color!.withOpacity(0.5)
                      : context.primaryColor.withOpacity(0.5);
                }

                return _color ?? context.primaryColor;
              },
            ),
          ),
          onPressed: isLoading ? null : _onPressed,
          child: isLoading
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
