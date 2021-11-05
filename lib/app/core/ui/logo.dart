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
        SizedBox(
          child: Text(
            'Onde',
            style: TextStyle(
              fontSize: 45.sp,
              color: context.primaryColor,
              fontWeight: FontWeight.bold,
              height: 0.999.h,
            ),
            textHeightBehavior: const TextHeightBehavior(
              leadingDistribution: TextLeadingDistribution.even,
            ),
          ),
        ),
        Text(
          '?',
          style: TextStyle(
            fontSize: 85.sp,
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
            height: 0.8.h,
          ),
          textHeightBehavior: const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
        Text(
          'Gastei',
          style: TextStyle(
            fontSize: 45.sp,
            color: context.primaryColor,
            fontWeight: FontWeight.bold,
            height: 0.8.h,
          ),
          textHeightBehavior: const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even,
          ),
        ),
      ],
    );
  }
}
