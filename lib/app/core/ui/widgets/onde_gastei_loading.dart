import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OndeGasteiLoading extends StatelessWidget {
  const OndeGasteiLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
        strokeWidth: 1.w,
      ),
    );
  }
}
