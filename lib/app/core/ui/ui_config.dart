import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';

class UiConfig {
  UiConfig._();

  static String get title => 'OndeGastei';

  static ThemeData get theme => ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            //statusBarBrightness: Brightness.light
          ),
          color: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Constants.iconThemeColor,
          ),
          titleTextStyle: GoogleFonts.jost(
            color: Constants.titleTextStyleColor,
            fontSize: 23.sp,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        primaryColor: Constants.primaryColor,
        primaryColorDark: Constants.primaryColorDark,
        primaryColorLight: Constants.primaryColorLight,
        primarySwatch: Constants.primarySwatch,
        textTheme: TextTheme(
          bodyText2: GoogleFonts.jost(
            color: Constants.bodyText2Color,
          ),
          subtitle1: GoogleFonts.jost(
            color: Constants.subtitle1Color,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Constants.primaryColor,
          primary: Constants.primaryColor,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Constants.primaryColor,
          selectionColor: Constants.primaryColor.withAlpha(50),
          selectionHandleColor: Constants.primaryColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Constants.hintStyleColor,
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
