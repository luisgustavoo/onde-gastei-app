import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onde_gastei_app/app/core/ui/onde_gastei_material_color.dart';

class UiConfig {
  UiConfig._();

  static String get title => 'OndeGastei';

  static ThemeData get theme => ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,

          ),
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
          labelStyle: const TextStyle(
            color: Color(0xFFC0C2D1),
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      );
}
