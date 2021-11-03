import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/theme_extension.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Onde',
          style: TextStyle(
            fontSize: 40.sp,
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '?',
          style: TextStyle(
            fontSize: 72.sp,
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Gastei',
          style: TextStyle(
            fontSize: 36.sp,
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
