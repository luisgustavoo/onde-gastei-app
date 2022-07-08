import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';

class UiConfig {
  UiConfig._();

  static String get title => 'OndeGastei';

  static ThemeData get themeLight => ThemeData(
        // useMaterial3: true,
        fontFamily: 'Jost',
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            // statusBarBrightness: Brightness.dark,
          ),
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Constants.titleTextStyleColor,
            fontSize: 23.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Jost',
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Constants.iconThemeColor,
          ),
        ),

        iconTheme: const IconThemeData(
          color: Constants.iconThemeColor,
        ),
        primaryColor: Constants.primaryColor,
        primaryColorDark: Constants.primaryColorDark,
        primaryColorLight: Constants.primaryColorLight,
        primarySwatch: Constants.primarySwatch,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Constants.primaryColor,
        ),
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            color: Constants.bodyText2Color,
          ),
          subtitle1: TextStyle(
            color: Constants.subtitle1Color,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Constants.primaryColor,
          primary: Constants.primaryColor,
          brightness: Brightness.light,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Constants.primaryColor,
          selectionColor: Constants.primaryColor.withAlpha(50),
          selectionHandleColor: Constants.primaryColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Constants.hintStyleColor,
            fontFamily: 'Jost',
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Constants.fillColor,
          filled: true,
          labelStyle: TextStyle(
            color: Constants.labelStyleColor,
            fontSize: 12.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      );
}
