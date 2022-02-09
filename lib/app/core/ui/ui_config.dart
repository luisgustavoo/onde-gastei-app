import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onde_gastei_app/app/core/ui/onde_gastei_material_color.dart';

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
            color: Color(0xFF585666),
          ),
          titleTextStyle: GoogleFonts.jost(
            color: const Color(0xFF585666),
            fontSize: 23.sp,
            fontWeight: FontWeight.w500,
          ),
          centerTitle: true,
        ),
        primaryColor: const Color(0xFF32B768),
        primaryColorDark: const Color(0xff278F51),
        primaryColorLight: const Color(0xffDAF2E4),
        primarySwatch: OndeGasteiMaterialColor.primarySwatch,
        textTheme: TextTheme(
          bodyText2: GoogleFonts.jost(
            color: const Color(0xFF585666),
          ),
          subtitle1: GoogleFonts.jost(
            color: const Color(0xFF585666),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF32B768),
          primary: const Color(0xFF32B768),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: const Color(0xFF32B768),
          selectionColor: const Color(0xFF32B768).withAlpha(50),
          selectionHandleColor: const Color(0xFF32B768),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Color(0xFFC0C2D1),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: const Color(0xFFEFEFEF),
          filled: true,
          labelStyle: TextStyle(
            color: const Color(0xFFC0C2D1),
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
