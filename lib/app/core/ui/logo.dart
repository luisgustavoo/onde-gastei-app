import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            fontSize: 45.sp,
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
            // height: 0.999.h,
          ),
        ),
        Text(
          '?',
          style: TextStyle(
            fontSize: 85,
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
            // height: 0.8.h,
          ),
        ),
        Text(
          'Gastei',
          style: TextStyle(
            fontSize: 45,
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
            // height: 0.8.h,
          ),
        ),
      ],
    );
  }
}
